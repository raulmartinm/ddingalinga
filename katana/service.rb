=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
=end

require_relative 'server'
require_relative 'payload'
require_relative './api/action'
require_relative 'logging'

class ServiceServer < ComponentServer

	# Name of service action this service handles.
	# 
    # :rtype: str
    #
	def action
		return @cli_args[:action]
	end

    def get_response_meta(payload)
        meta = @@EMPTY_META

        htransport = payload.get_path("command","arguments","transport") {nil}
        Loggging.log.debug " get_response_meta htransport = #{htransport}"
        if htransport.nil?
            return meta
        end
        transport = TransportPayload.new
        transport.set_data(htransport)

        # When a download is registered add files flag
        hbody = transport.get_path("body") {nil}
        Loggging.log.debug " get_response_meta hbody = #{(hbody.nil? ? 'nil': hbody)}"
        if hbody != nil
            meta = @@DOWNLOAD
        end

        # Add meta for service call when inter service calls are made
        hcall = transport.get_path("calls", component_name, component_version) {nil}
        Loggging.log.debug " get_response_meta hcall = #{(hcall.nil? ? 'nil': hcall)}"
        if hcall.nil?
           meta = @@SERVICE_CALL # TODO concat response 'meta += @@SERVICE_CALL'

           # Skip call files check when files flag is already in meta
=begin
            # Skip call files check when files flag is already in meta
            if FILES not in meta:
                # Add meta for files only when service calls are made.
                # Files are setted in a service ONLY when a call to
                # another service is made.
                files = get_path(transport, 'files', None)
                for call in calls:
                    files_path = '{}/{}/{}'.format(
                        get_path(call, 'name'),
                        get_path(call, 'version'),
                        get_path(call, 'action'),
                        )
                    # Add flag and exit when at least one call has files
                    if path_exists(files, files_path):
                        meta += FILES
                        break
=end
        end

        Loggging.log.debug "get_response_meta meta = #{meta}"
        return meta;
    end


	# Create a component instance for current command payload.
	#
    # :param payload: Command payload.
    # :type payload: `CommandPayload`
	# 
    # :rtype: `Action`
    #
	def create_component_instance(payload)

		# Save transport locally to use it for response payload
		@transport = TransportPayload.new
		@transport.set_data(payload.get_path("command","arguments","transport"))

		paylodParam = Payload.new
		paylodParam.set_payload(payload.get_path("command","arguments","params"))
        Loggging.log.debug " create_component_instance paylodParam = #{paylodParam.to_s}"

		return Action.new(
			self.action(),
            paylodParam,
            @transport,
            nil, # TODO self.source_file()
            self.component_name,
            self.component_version,
            self.platform_version,
            self.get_vars,
            self.debug,
		)
	end

	# Convert component to a command result payload.
	#
    # :params payload: Command payload from current request.
    # :type payload: `CommandPayload`
    # :params component: The component being used.
    # :type component: `Component`
	#
    # :returns: A command result payload.
    # :rtype: `Hash of type CommandResultPayload`
    #    
	def component_to_payload(payload, component)
        return @transport.get_payload
    end


	def create_error_payload(exc, action, payload)
        # Add error to transport and return transport
        @transport = TransportPayload.new
        @transport.set_data(payload.get_path("command","arguments","transport"))        
        @transport.deep_nestdata("errors",action.get_name,action.get_version,ErrorPayload.new.init(exc.to_s))        
        return @transport.get_payload
     end
end