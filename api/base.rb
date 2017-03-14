require_relative '../errors'
require_relative '../logging'

# Exception class for API errors.
#
class ApiError < KatanaError
end


# Base API class for SDK components.
#
class Api
	
	def initialize(component, path, name, version, framework_version, variables=nil, debug=false)
		@component = component
		@path = path
		@name = name
		@version = version
		@framework_version = framework_version
		@variables = variables
		@debug = debug
		# @schema = get_schema_registry()
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

	# Gets all component variables.
	#	
	# rtype: hash or dict
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
        for name in self._schema.get_service_names():
            for version in self._schema.get(name).keys():
                services.append({'name': name, 'version': version})

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
        if '*' in version:
            try:
                version = VersionString(version).resolve(
                    self._schema.get(name, {}).keys()
                    )
                payload = self._schema.get('{}/{}'.format(name, version), None)
            except KatanaError:
                payload = None
        else
            payload = self._schema.get('{}/{}'.format(name, version), None)
        end

        if not payload:
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
        debug:#@debug)"
	end
end