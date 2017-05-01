=begin
Python 3 SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative '../../logging'
require_relative '../../payload'


# File parameter schema in the framework.
#
class FileSchema
 

    def initialize(name, payload)
        @name = name
        @payload = Payload.new(payload)
    end

    # Get file parameter name.
    #
    # :rtype: str
    #
    def get_name
        return @name
    end

    # Get mime type.
    #
    # :rtype: str
    #
    def get_mime
        return @payload.get_path("mime"){"text/plain"} 
    end

    # Check if file parameter is required.
    #
    # :rtype: bool
    #
    def is_required
        return @payload.get_path("required"){false}
    end

    # Get minimum file size allowed for the parameter.
    #
    # Returns 0 if not defined.
    #
    # :rtype: int
    #
    def get_max
        return @payload.get_path("max"){10000}
    end

    # Check if maximum size is inclusive.
    #
    # When max is not defined inclusive is False.
    #
    # :rtype: bool
    #
    def is_exclusive_max
        if not @payload.path_exists("max")
            return false
        end

        return @payload.get_path("exclusive_max"){false}
    end

    # Get minimum file size allowed for the parameter.
    #
    # Returns 0 if not defined.
    #
    # :rtype: int
    # 
    def get_min
        return @payload.get_path("min"){0}
    end

    # Check if minimum size is inclusive.
    #
    # When min is not defined inclusive is False.
    #
    # :rtype: bool
    #
    def is_exclusive_min
        if not @payload.path_exists("min")
            return false
        end

        return @payload.get_path("exclusive_min"){false}
    end

    # Get HTTP file param schema.
    #
    # :rtype: HttpFileSchema
    #
    def get_http_schema
        return HttpFileSchema.new(self.get_name(), @payload.get_path("http"){{}})
    end

end

# HTTP semantics of a file parameter schema in the framework.
#
class HttpFileSchema

    def initialize(name, payload)
        @name = name
        @payload = Payload.new(payload)        
    end

    # Check if the Gateway has access to the parameter.
    #
    # :rtype: bool
    #
    def is_accessible
        return @payload.get_path("gateway"){true}
    end

    # Get name as specified via HTTP to be mapped to the name property.
    #
    # :rtype: str
    #
    def get_param
        return @payload.get_path("param"){@name}
    end
end