=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require 'optparse'
require_relative '../logging'
Thread.abort_on_exception = true

# Component runner.
#
#  This class allows to isolate Component implementation details and
#  keep the Component itself consisten with KATANA SDK specifications.
class ComponentRunner

	@@WORKER_ENDPOINT = "inproc://workers"
	@@VAR_WORKERS = "workers"

	# Constructor.
	# 
	# :param component: The component to run.
	# :type component: Component
	# :param server_cls: Class for the component server.
	# :type server_cls: ComponentServer
	# :param help: Help text for the CLI command.
	# :type help: str
	#
	def initialize(componet, worker, help, *args)
		@worker = worker
		@component = component
		@help = help		
		@args = args

		@callback = nil
		@startup_callback = nil
        @shutdown_callback = nil
        @error_callback = nil
        @callbacks = nil
	end

	def args
		return @args
	end

	# TCP port number.
	#
    # :rtype: str or None
    #
 	def tcp_port
        return @options[:tcp]
	end


	# Component name.
	#
    # :rtype: str
    #
	def name
		return @options[:name]
	end

	# Component type.
	#
	# :rtype: str
	#
	def component_type
		return @options[:component]
    end    

	# Component action name.
	#
	# :rtype: str
	#
	def action_name
        return options[:action]
    end

	# Check if debug is enabled for current component.
	#
	# :rtype: bool
	#
	def debug
        return @options[:debug]
    end

    def get_var(var_name)
    	if @options[:var]!=nil
    		return @options[:var][var_name]
    	end
    	return nil
    end

	def get_argument_options(argv)
		options = {}
		OptionParser.new do |opts|
		  	opts.banner = "\nUsage: example.rb [options]\n"		  
      	  	opts.separator ""
			opts.separator "Specific options:"

		  	opts.on("-c", "--component component", [:service, :middleware], "Component type") do |component|
				options[:component] = component
		  	end

			options[:compact_names] = false
		  	opts.on("-d", "--disable-compact-names", "Use full property names instead of compact in payloads.") do |compact_names|
				options[:compact_names] = compact_names
		  	end

		  	opts.on("-n", "--name name", String, "Component name") do |name|
				options[:name] = name
		  	end

		  	opts.on("-f", "--framework-version framework_version", "Katana framework version") do |framework_version|
				options[:framework_version] = framework_version
		  	end

			options[:quit] = false
		  	opts.on("-q", "--quit", "") do |quit|
				options[:quit] = quit
		  	end

		  	opts.on("-s", "--socket [socket]", "IPC socket name") do |socket|
				options[:socket] = socket
		  	end

			options[:tcp] = nil
		  	opts.on("-t", "--tcp [tcp]", Integer, "TCP port") do |tcp|
				options[:tcp] = tcp
		  	end

		  	opts.on("-v", "--version version", "Component version") do |version|
				options[:version] = version
		  	end

			options[:debug] = false
		  	opts.on("-D", "--debug", "") do |debug|
				options[:debug] = debug
		  	end

			opts.on("-V", "--var var", "") do |var|				
				if options[:var] == nil
					options[:var] = {}
				end	
				options[:var].merge!( Hash[*(var.split('=').map(&:to_s))] )				
			end		  

			opts.on("-h", "--help", "Displays help") do
				puts opts
				exit
			end
		end.parse!(argv)

		return options
	end



    # Set a callback to be run during startup.
	# 
    # :param callback: A callback to run on startup.
    # :type callback: function
    #
    def set_startup_callback(callback)
        @startup_callback = callback
    end

	# Set a callback to be run during shutdown.
	# 
    # :param callback: A callback to run on shutdown.
    # :type callback: function
    #
    def set_shutdown_callback(callback)
        @shutdown_callback = callback
    end

	# Set a callback to be run on message callback errors.
	# 
    # :param callback: A callback to run on message callback errors.
    # :type callback: function
    #
    def set_error_callback(callback)
        @error_callback = callback
    end

	# Set message callbacks for each component action.
	# 
    # :params callbacks: Callbacks for each action.
    # :type callbacks: dict
    #
    def set_callbacks(callbacks)
        @callbacks = callbacks
    end

	# Start component server.
	#
    # This call blocks the caller script until server finishes.
    #
    # Caller script is stopped when server finishes, by exiting
    # with an exit code.
    # http://zguide.zeromq.org/page:all#Multithreading-with-ZeroMQ (Multithreading with ZeroMQ)
    #
    def start_componet()
		Loggging.log.debug "Starting component server..."


		# Create channel for TCP or IPC conections
        if tcp_port()!= nil
        	Loggging.log.debug "tcp_port = #{tcp_port()}"
            channel = "tcp://127.0.0.1:#{tcp_port()}"
        else
            # Abstract domain unix socket
            channel = "ipc://#{socket_name()}"
        end
        Loggging.log.debug "channel = #{channel}"

		# Use pattern Multithreading with ZeroMQ
		context = ZMQ::Context.new

		# socket to listen for clients
		clients = context.socket(ZMQ::ROUTER)
		clients.bind(channel)

		# socket to talk to workers
		workers = context.socket(ZMQ::DEALER)
		workers.bind(@@WORKER_ENDPOINT)

		# Launch pool of worker threads
		workers_num = get_var(@@VAR_WORKERS)
		workers_num = !workers_num.nil? ? workers_num.to_i : 1 
		Loggging.log.debug "workers_num = #{workers_num}"
		worker_threads = []
		workers_num.times do |i|

			Loggging.log.debug "workers run = #{i}"
			Loggging.log.debug "worker @worker = #{@worker}"

			# initialization worker
			@worker.set_context(context)
			@worker.set_callbacks(@callbacks)
			@worker.set_args(@options)

			# launching component
		  	# th = Thread.new {@worker.run()}
		  	worker_threads << Thread.new do
		  		@worker.run()
		  	end
		end

		# Connect work threads to client threads via a queue
		ZMQ::Device.new(clients,workers,nil)

		#  We never get here but clean up anyhow
		clients.close();
		workers.close();
		context.term();
    end


	# Run SDK component.
	#
    # Callback must be a callable that receives a
    # `geniac.api.base.Api` argument.
    #
    # Calling this method checks command line arguments before
    # component server starts.
	#
    # :param callback: Callable to handle requests.
    # :type callback: A callable.
    #
	def run()

		# Apply CLI options to command
		@options = get_argument_options(@args)

		# Initialize component logging
		if (debug())
			Loggging.log.level = Logger::DEBUG
		end		
		Loggging.log.debug @options

		# Run SDK component
		start_componet()
	end
end