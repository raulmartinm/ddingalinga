require_relative '../errors'
require_relative '../logging'

# Exception class for component errors.
class ComponentError < KatanaError
end

# Base KATANA SDK component class.
class Component	


	def initialize(worker, *args)
		@resources = {}
        @startup_callback = nil
        @shutdown_callback = nil
        @error_callback = nil
        @callbacks = {}
        @runner = nil
        @logger = Loggging.log
	end


	def runner(runner)
		@runner = runner
	end

	# Run SDK component.
	#
    # Callback must be a callable that receives a
    # `katana.api.base.Api` argument.
    #
    # Calling this method checks command line arguments before
    # component server starts.
    #
    # :param callback: Callable to handle requests.
    # :type callback: A callable.
	def run(callback)
		if @runner == nil
			@logger.error "No component runner defined"
			# Child classes must create a component runner instance
            raise ComponentError.new("No component runner defined")
		end 

		@runner.run(callback)
=begin
       if not self._runner:
            # Child classes must create a component runner instance
            raise Exception('No component runner defined')

        if self.__startup_callback:
            self._runner.set_startup_callback(self.__startup_callback)

        if self.__shutdown_callback:
            self._runner.set_shutdown_callback(self.__shutdown_callback)

        if self.__error_callback:
            self._runner.set_error_callback(self.__error_callback)

        # Create the global schema registry instance on run
        SchemaRegistry()

        self._runner.set_callbacks(self._callbacks)
        self._runner.run()
=end
        
	end

	# Check if a resource name exist.
	#
    # :param name: Name of the resource.
    # :type name: str
    # 
    # :rtype: bool
    def has_resource(name)
        return @resources.key?(name) # Exists key in Hash
        return @resources.include?(name) # Exists value into Array
    end

	# Store a resource.
	# 
    # :param name: Name of the resource.
    # :type name: str
    # :param callable: A callable that returns the resource value.
    # :type callable: function
    #
    #:raises: ComponentError
	def set_resource(name, callable)
        value = callable()
        if value == nil
            err = "Invalid result value for resource '#{name}'"
            @logger.error err
            raise ComponentError.new(err)
        end

        @resources[name] = value
    end

    # Get a resource.
    #
    # :param name: Name of the resource.
    # :type name: str
	#
    # :raises: ComponentError
	#
    # :rtype: object
    def get_resource(name)
      
        if !has_resource(name)
        	err = "Resource '#{name}' not found"
        	@logger.error err
            raise ComponentError.new(err)
        end

        return @resources[name]
    end

    # Register a callback to be called during component startup.
    #
    # Callback receives a single argument with the Component instance.
    # :param callback: A callback to execute on startup.
    # :type callback: function
    # :rtype: Component
    def startup(callback)
        @startup_callback = callback
        return self
    end

	# Register a callback to be called during component shutdown.
	#
    # Callback receives a single argument with the Component instance.
    # 
    # :param callback: A callback to execute on shutdown.
    # :type callback: function
    # 
    # :rtype: Component
    def shutdown(callback)
        @shutdown_callback = callback
        return self
	end



	# Register a callback to be called on message callback errors.
	#
	# Callback receives a single argument with the Exception instance.
	#
	# :param callback: A callback to execute a message callback fails.
	# :type callback: function
	#
	# :rtype: Component
	def error(callback)
		@error_callback = callback
		return self
	end

	# Write a value to KATANA logs.
	#
 	# Given value is converted to string before being logged.
 	#
 	# Output is truncated to have a maximum of 100000 characters.
	def log(value)
        @logger.debug(value_to_log_string(value))
    end
end