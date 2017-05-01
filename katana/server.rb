=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
=end

require 'ffi-rzmq'
require 'msgpack'
require 'deep_fetch'
require_relative 'payload'
require_relative 'logging'

# Component worker thread class.
#
# This class handles component requests.
#
class ComponentServer

    @@WORKER_ENDPOINT = "inproc://workers"

	# Constants for response meta frame
	@@EMPTY_META = 0x00
	@@SERVICE_CALL = 0x01
	@@FILES = 0x02
	@@TRANSACTIONS = 0x03
	@@DOWNLOAD = 0x04


	def initialize(context = nil, callbacks = nil, cli_args = nil)
		@context = context
		@callbacks = callbacks
		@cli_args = cli_args
	end

    def set_context(context)
        @context = context
    end

    def set_callbacks(callbacks)
        @callbacks = callbacks
    end

    def set_args(cli_args)
        @cli_args = cli_args
    end
    
    def component_name
        return @cli_args[:name]
    end

    def component_version
        return @cli_args[:version]
    end

    def component_title
        return "'#{component_name}' (#{component_version})"
    end

    def framework_version
        return @cli_args[:framework_version]
	end

    def variables        
        return @cli_args[:var]
    end

	# Check if debug is enabled for current component.
	#
	# :rtype: bool
    #    
	def debug
        return @cli_args[:debug]
    end

    # Check if payloads should use compact names.
    #
    # :rtype: bool
    #    
    def compact_names
        return @cli_args[:compact_names]
    end


    # Create a new multipart error stream.
    # 
    # :param message: Error message.
    # :type message: str
    #
    # :rtype: list
    #
    def create_error_stream(message)
        meta = ZMQ::Message.new
        meta.copy_in_bytes([@@EMPTY_META].pack('C*'),1)

        msg = ZMQ::Message.new(message.to_msgpack)
        return [meta, msg]
    end


	# Create a payload for the error response.
	#
    # :params exc: The exception raised in user land callback.
    # :type exc: `Exception`
    # :params component: The component being used.
    # :type component: `Component`
	#
    # :returns: A result payload.
    # :rtype: `Payload`
    #
	def create_error_payload(exc, component, payload=nil)
        raise NotImplementedError.new("You must implement create_error_payload.")
    end


	# Create a component instance for a payload.
	#
    # The type of component created depends on the payload type.
	#
    # :param payload: A payload.
    # :type payload: Payload.
	#
    # :raises: HTTPError
	#
    # :returns: A component instance for the type of payload.
    # :rtype: `Component`.
    #
   	def create_component_instance(payload)
       raise NotImplementedError.new("You must implement create_component_instance.")
    end

	# Convert callback result to a command result payload.
	#
    # :params command_name: Name of command being executed.
    # :type command_name: str
    # :params component: The component being used.
    # :type component: `Component`
    #
    # :returns: A command result payload.
    # :rtype: `CommandResultPayload`
    #
    def component_to_payload(command_name, component)
        raise NotImplementedError.new("You must implement component_to_payload.")
    end


    # Update schema registry with new service schemas.
    # 
    # :param stream: Mappings stream.
    # :type stream: bytes
    #
    def update_schema_registry(mapping_data)
        Loggging.log.debug "Updating schemas for Services ..."
        begin
            @schema_registry.update_registry(mapping_data)
        ensure
            Loggging.log.error "Failed to update schemas"
            Exception.new("Failed to update schemas")
        end
    end

    # Process a request payload.
    # 
    # :param action: Name of action that must process payload.
    # :type action: str
    # :param payload: A command payload.
    # :type payload: CommandPayload
    # 
    # :returns: A Payload with the component response.
    # 
	def process_payload(action, payload)

        if payload.get_path("command").nil?
            Loggging.log.debug "Payload missing command"
            return ErrorPayload.new.init("Internal communication failed")
        end

        command_name = payload.get_path("command","name")

        # Create a component instance using the command payload and
        # call user land callback to process it and get a response component.
        component = create_component_instance(action, payload)
        if component.nil?
            return ErrorPayload.new.init("Internal communication failed")
        end


        # Call callback
        begin
            component = @callbacks[action].call(component)
        rescue Exception => exc
            Loggging.log.error "Exception: #{exc}"
            payload = create_error_payload(exc,component,payload)
        ensure
            # TODO 2 arguments for middleware => payload = component_to_payload(payload, component)
            payload = component_to_payload(payload, component) 
        end

        # Convert callback result to a command payload
        Loggging.log.debug " process_payload replay: #{CommandResultPayload.new.init(command_name,payload)}"
        return CommandResultPayload.new.init(command_name,payload) # return hash
               
	end


    # Process error when uses zmq
    #
    def error_check(rc)

        if ZMQ::Util.resultcode_ok?(rc)
            false
        else
            Loggging.log.error "Operation failed, errno [#{ZMQ::Util.errno}] description [#{ZMQ::Util.error_string}]"
            caller(1).each { |callstack| Loggging.log.error(callstack) }
            true
        end
    end

    # Start handling incoming component requests and responses.
    #
    # This method starts an infinite loop that polls socket for    
    # incoming requests.
    #
    def run

        Loggging.log.debug "worker = #{component_name()} , Thread = #{Thread.current}"

        # array with packages to response
        response_data = []

        # When compact mode is enabled use long payload field names
        commandPayload = CommandPayload.new        
        commandPayload.set_fieldmappings(compact_names)

        # Socket to talk to dispatcher
        receiver = @context.socket(ZMQ::REP)
        receiver.connect(@@WORKER_ENDPOINT)

        loop do
            Loggging.log.debug "waiting to receive messages....."

            # receive menssage from userland (Multipart request frames = [action, mappings, stream])
            messages = []
            receiver.recvmsgs(messages)

            # 'acton' >> Get action name
            received_action = messages[0].copy_out_string
            Loggging.log.debug "Received request byte 'action': [#{received_action}]"
            if !@callbacks.has_key?(received_action)
                error = "Invalid action for component #{self.component_title}: '#{received_action}'"
                Loggging.log.error error
                response_data = create_error_stream(error)
            end 

            if !response_data.any?

                # 'mappings' >> Update global schema registry when mappings are sent
                received_mappings = messages[1].copy_out_string
                Loggging.log.debug "Received request byte 'mappings': [#{received_mappings}]"
                # TODO Update global schema registry when mappings are sent
                if !received_mappings.nil?
                    Loggging.log.debug "Update global schema registry when mappings are sent"
                end

                # 'stream' >> Call request handler and send response back
                received_stream = messages[2].copy_out_string
                Loggging.log.debug "Received request byte: [#{received_stream}]"

                # unpack message recived
                commandPayload.set_payload(MessagePack.unpack(received_stream))
                Loggging.log.debug "Received commandPayload: [#{commandPayload}]"

                # Process message reviced
                commandResultPayload = process_payload(received_action, commandPayload)
                Loggging.log.debug "Responser commandResultPayload: [#{commandResultPayload}]"

                # send type of response
                meta = ZMQ::Message.new
                meta.copy_in_bytes([get_response_meta(commandPayload)].pack('C*'),1)
                Loggging.log.debug "Responser meta: [#{meta}]"            
                #receiver.sendmsg(meta,ZMQ::SNDMORE)

                # Send reply back to client
                crmsg = ZMQ::Message.new(commandResultPayload.to_msgpack)
                #receiver.sendmsg(crmsg)

                response_data = [meta,crmsg]
            end

            # Send reply back to client
            Loggging.log.debug "Response data 'action' : [#{received_action}]: [#{response_data}]"
            #receiver.sendmsgs(response_data)
            receiver.sendmsg(response_data[0],ZMQ::SNDMORE)
            receiver.sendmsg(response_data[1])
        end
    end
end