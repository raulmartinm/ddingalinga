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

# Exception class for API errors.
#
class ApiError < KatanaError
end


# Base API class for SDK components.
#
class Api
	
	def initialize(component, path, name, version, framework_version, variables={}, compact_names=false, debug=false)
		@component = component
		@path = path
		@name = name
		@version = version
		@framework_version = framework_version
		@variables = variables
		@compact_names = compact_names
		@debug = debug
		@schema = get_schema_registry()
	end


	# Get source file path.
	#
	# Returns the path to the endpoint userland source file.
	#
	# returns: Source path file.
	# rtype: string
	#
	def get_path
		return @path
	end

	# Get component name.
	#
	# rtype: string
	#
	def get_name
		return @name
	end

	# Get component version.
	#	
	# rtype: string
	#
	def get_version
		return @version
	end

	# Get KATANA framework version.
	#	
	# rtype: string
	#
	def get_framework_version
		return @framework_version
	end

	# Get KATANA platform version.
	#	
	# rtype: hash or dict
	#
	def get_variables
		return @variables
	end

	# Get a single component variable.
	#	
	# :param name: Variable name.
    # :type name: str
    #
	def get_variable(key)
		return @variables[key] if @variables
    end

	# Determine if component is compact_names
	#
	# :rtype: bool
	#
	def is_compact_names
		return @compact_names
	end

	# Determine if component is running in debug mode.
	#
	# :rtype: bool
	#
	def is_debug
		return @debug
	end

    # Check if a resource name exist.
    #
    # :param name: Name of the resource.
    # :type name: str
    #
    # :rtype: bool
    #
    def has_resource()
        return @component.has_resource(name)
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
	def get_resource()
        return @component.get_resource(name)
	end

	# Get service names and versions.
	#
    # :rtype: list
    #
	def get_services()
        services = []
        for name in @schema.get_service_names()
            for version in @schema.get(name).keys()
                services.append({"name" => name, "version" => version})
            end
        end

        return services
	end

    # Get service schema.
	# 
    # Service version string may contain many `*` that will be
    # resolved to the higher version available. For example: `1.*.*`.
	# 
    # :param name: Service name.
    # :type name: str
    # :param version: Service version string.
    # :type version: str
	# 
    # :raises: ApiError
	# 
    # :rtype: ServiceSchema
    #
    def get_service_schema(name, version)
        # Resolve service version when wildcards are used
        if version.include? "*"
=begin        	
            begin

                version = VersionString(version).resolve(
                    @schema.get_path(name, {}).keys()
                )
                payload = @schema.get(name, version){nil}
            rescue KatanaError
                payload = nil
            end
=end            
        else
            payload = @schema.get(name, version){nil}
        end

        if payload.nil?
            error = "Cannot resolve schema for Service: '#{name}' (#{version})"
            raise ApiError.new(error)
        end

        return ServiceSchema.new(name, version, payload)
    end

	def to_s
      "(component:#@component,\n
        path:#@path,\n
        name:#@name,\n
        version:#@version,\n
        framework_version:#@framework_version,\n
        variables:#@variables,\n
        compact_names:#@compact_names,\n
        debug:#@debug)"
	end
end