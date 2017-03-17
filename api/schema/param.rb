=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative '../../logging'
require_relative '../../payload'
require_relative '../../json'

# Parameter schema in the platform.
#
class ParamSchema

    def initialize(name, payload)
        @name = name
        @payload = payload
    end

    
    # Get parameter name.
    #
    # :rtype: str
    #
    def get_name
        return @name
    end

    # Get parameter value type.
    #
    # :rtype: str
    #
    def get_type
        return @payload.get_path("type"){"string"}
    end

    # Get parameter value format.
    #
    # :rtype: str
    #
    def get_format
        return @payload.get_path("format"){""}
    end

    
    # Get format for the parameter if the type property is set to "array".
    # 
    #     Formats:
    #       - "csv" for comma separated values (default)
    #       - "ssv" for space separated values
    #       - "tsv" for tab separated values
    #       - "pipes" for pipe separated values
    #       - "multi" for multiple parameter instances instead of multiple
    #         values for a single instance.
    # 
    # :rtype: str
    #
    def get_array_format
        return @payload.get('array_format', 'csv')
    end

    # Get ECMA 262 compliant regular expression to validate the parameter.
    #
    # :rtype: str
    #
    def get_pattern
        return @payload.get_path("pattern"){""}
    end

    # Check if the parameter allows an empty value.
    #
    # :rtype: bool
    #
    def allow_empty
        return @payload.get_path("allow_empty"){false}
    end

    # Check if the parameter has a default value defined.
    #
    # :rtype: bool
    #
    def has_default_value
        return @payload.path_exists("default")
    end

    # Get default value for parameter.
    #
    # :rtype: str
    #
    def get_default_value
        return @payload.get_path("default"){""} 
    end

    # Check if parameter is required.
    #
    # :rtype: bool
    #
    def is_required
        return @payload.get_path("required"){false}
    end

    # Get JSON items defined for the parameter.
    #
    # An empty string is returned when parameter type is not "array".
    #
    # :rtype: list
    #
    def get_items
=begin        
        if self.get_type() != 'array':
            return ''

        if not @payload.path_exists('items'):
            return ''

        try:
            # Items must be a valid JSON string
            return json.loads(@payload.get('items'))
        except:
            LOG.exception('Value for "items" is not valid JSON')
            return ''
=end
    end

    
    # Get maximum value for parameter.
    #
    # :rtype: int
    #
    def get_max
        return @payload.get_path("maximum"){10000} # sys.maxsize
    end

    # Check if max value is inclusive.
    #
    # When max is not defined inclusive is False.
    #
    # :rtype: bool
    #
    def is_exclusive_max
        if !@payload.path_exists("maximum")
            return false
        end

        return @payload.get_path("exclusive_maximum"){false}
    end

    # Get minimum value for parameter.
    # 
    # :rtype: int
    #
    def get_min
        return @payload.get_path("maximum"){-10001} # -sys.maxsize - 1
    end

    
    # Check if minimum value is inclusive.
    #
    # When min is not defined inclusive is False.
    #
    # :rtype: bool
    #
    def is_exclusive_min
        if not @payload.path_exists('minimum'):
            return False

        return @payload.get_path("exclusive_minimum"){false}
    end

    
    # Get max length defined for the parameter.
    # 
    # result is -1 when this values is not defined.
    # 
    # :rtype: int
    def get_max_length
        return @payload.get_path("maximum_length"){-1}
    end

    
    # Get minimum length defined for the parameter.
    #
    # result is -1 when this values is not defined.
    #
    # :rtype: int
    #
    def get_min_length
        return @payload.get_path("minimum_length"){-1}
    end

    
    # Get maximum number of items allowed for the parameter.
    # 
    # Result is -1 when type is not "array" or values is not defined.
    # 
    # :rtype: int
    #
    def get_max_items
        if self.get_type() != "array"
            return -1
        end

        return @payload.get_path("maximum_items"){-1}
    end

    
    # Get minimum number of items allowed for the parameter.
    # 
    # Result is -1 when type is not "array" or values is not defined.
    # 
    # :rtype: int
    #
    def get_min_items
        if self.get_type() != "array"
            return -1
        end

        return @payload.get_path("minimum_items"){-1}
    end

    # Check if param must contain a set of unique items.
    #
    # :rtype: bool
    #
    def has_unique_items
        return @payload.get_path("unique_items"){false}
    end

    # Get the set of unique values that parameter allows.
    #
    # :rtype: list
    #
    def get_enum
        if !@payload.path_exists('enum')
            return ""
        end

        begin
            # Items must be a valid JSON string
            return json.loads(@payload.get_path("enum"))
        rescue Exception => exc
            Loggging.log.debug "Value for 'enum' is not valid JSON"
            return ""
    end

    
    # Get value that parameter must be divisible by.
    #
    # Result is -1 when this property is not defined.
    #
    # :rtype: int
    #
    def get_multiple_of
        return @payload.get_path("multiple_of"){-1}
    end

    # Get HTTP param schema.
    #
    # :rtype: HttpParamSchema
    #
    def get_http_schema
        return HttpParamSchema.new(self.get_name(), @payload.get_path("http"){{}})
    end

# HTTP semantics of a parameter schema in the platform.
#
class HttpParamSchema


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

    
    # Get location of the parameter.
    #
    # :rtype: str
    #
    def get_input
        return @payload.get_path("input"){"query"}
    end

    # Get name as specified via HTTP to be mapped to the name property.
    #
    # :rtype: str
    #
    def get_param
        return @payload.get_path("param"){@name}
    end
