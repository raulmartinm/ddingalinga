require_relative '../../logging'
require_relative '../../payload'

# Service schema in the platform.
#
class ServiceSchema


    def initialize(name, version, payload)
        @name = name
        @version = version
        @payload = Payload.new(payload)
        @actions = @payload.get('actions', {})
    end

    # Get Service name.
    #
    # :rtype: str
    def get_name
        # return @name
    end

    # Get Service version.
    #
    # :rtype: str
    def get_version
        # return @version
    end

    
    # Get Service action names.
    #
    # :rtype: list
    def get_actions
        # return @actions.keys()
    end

    # Check if an action exists for current Service schema.
    #
    # :param name: Action name.
    # :type name: str
    #
    # :rtype: bool
    def has_action(name)
        #return name in @actions
    end

    # Get schema for an action.
    # 
    # :param name: Action name.
    # :type name: str
    # 
    # :raises: ServiceSchemaError
    # 
    # :rtype: ActionSchema
    def get_action_schema(name)
=begin       
        if not self.has_action(name):
            error = 'Cannot resolve schema for action: {}'.format(name)
            raise ServiceSchemaError(error)

        return ActionSchema(name, @actions[name])
=end
    end

    
    # Get HTTP Service schema.
    #
    # :rtype: HttpServiceSchema
    def get_http_schema
        # return HttpServiceSchema(@payload.get('http', {}))
    end
end


# HTTP semantics of a Service schema in the platform.
#
class HttpServiceSchema
 

    def initialize(payload)
        @payload = Payload(payload)
    end

    # Check if the Gateway has access to the Service.
    # 
    # :rtype: bool
    def is_accessible
        #return @payload.get('gateway', True)
    end

    
    # Get base HTTP path for the Service.
    #
    # :rtype: str
    def get_base_path
        #return @payload.get('base_path', '')
    end
end
