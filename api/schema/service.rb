=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative '../../logging'
require_relative '../../payload'
require_relative 'action'
require_relative 'error'

# Service schema in the platform.
#
class ServiceSchema


    def initialize(name, version, payload)
        @name = name
        @version = version
        @payload = payload
        @actions = @payload.get_path("actions"){{}}
    end

    # Get Service name.
    #
    # :rtype: str
    #
    def get_name
        return @name
    end

    # Get Service version.
    #
    # :rtype: str
    #
    def get_version
        return @version
    end

    
    # Get Service action names.
    #
    # :rtype: list
    #
    def get_actions
        return @actions.keys()
    end

    # Check if an action exists for current Service schema.
    #
    # :param name: Action name.
    # :type name: str
    #
    # :rtype: bool
    #
    def has_action(name)
        return  !@actions[name].nil?
    end

    # Get schema for an action.
    # 
    # :param name: Action name.
    # :type name: str
    # 
    # :raises: ServiceSchemaError
    # 
    # :rtype: ActionSchema
    #
    def get_action_schema(name)
        if !self.has_action(name)
            error = "Cannot resolve schema for action: #{name}"
            raise ServiceSchemaError.new error

        return ActionSchema.new (name, @actions[name])
    end

    
    # Get HTTP Service schema.
    #
    # :rtype: HttpServiceSchema
    #
    def get_http_schema
        return HttpServiceSchema.new(@payload.get_path("http"){{}})
    end
end


# HTTP semantics of a Service schema in the platform.
#
class HttpServiceSchema
 

    def initialize(payload)
        @payload = Payload.new(payload)        
    end

    # Check if the Gateway has access to the Service.
    # 
    # :rtype: bool
    #
    def is_accessible
        return @payload.get_path("gateway"){true}
    end

    
    # Get base HTTP path for the Service.
    #
    # :rtype: str
    #
    def get_base_path
        return @payload.get_path("base_path"){""}
    end
end
