=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end
require_relative '../errors'
require_relative '../logging'
require_relative '../schema'

# Exception class for component errors.
#
class ComponentError < KatanaError
end

# Base KATANA SDK component class.
#
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
    # Calling this method checks command line arguments before
    # component server starts.
    #
    def run(self)

        if @runner == nil
            @logger.error "No component runner defined"
            # Child classes must create a component runner instance
            raise ComponentError.new("No component runner defined")
        end 

        if @startup_callback
            @runner.set_startup_callback(@startup_callback)
        end

        if @shutdown_callback
            @runner.set_shutdown_callback(@shutdown_callback)
        end

        if @error_callback
            @runner.set_error_callback(@error_callback)
        end

        # Create the global schema registry instance on run
        SchemaRegistry.new

        @runner.set_callbacks(@callbacks)
        @runner.run()
    end

	# Check if a resource name exist.
	#
    # :param name: Name of the resource.
    # :type name: str
    # 
    # :rtype: bool
    #
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
    # :raises: ComponentError
    #
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
    #
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
    #
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
    #
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
    #
	def error(callback)
		@error_callback = callback
		return self
	end

	# Write a value to KATANA logs.
	#
 	# Given value is converted to string before being logged.
 	#
 	# Output is truncated to have a maximum of 100000 characters.
    #
	def log(value)
        @logger.debug(value_to_log_string(value))
    end
end