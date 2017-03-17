=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative '../../logging'
require_relative '../../payload'
require_relative 'error'
require_relative 'param'
require_relative 'file'


# Error class for schema action errors.
#
class ActionSchemaError < ServiceSchemaError
end

# Action schema in the platform.
#
class ActionSchema
    

    def initialize(name, payload)
        @name = name
        @payload = Payload.new(payload)
        @params = @payload.get_path("params"){{}}
        @files = @payload.get_path("files"){{}}
    end

    # Check if action has been deprecated.
    #
    # :rtype: bool
    #
    def is_deprecated
        return @payload.get_path("deprecated"){false}
    end

    # Check if the action returns a collection of entities.
    #
    # :rtype: bool
    #
    def is_collection
        return @payload.get_path("collection"){false}
    end

    # Get action name.
    #
    # :rtype: str
    #
    def get_name
        return @name
    end

    # Get path to the entity.
    # 
    # :rtype: str
    #
    def get_entity_path
        return @payload.get_path("entity_path"){""}
    end

    
    # Get delimiter to use for the entity path.
    #
    # :rtype: str
    #
    def get_path_delimiter
        return @payload.get_path("path_delimiter"){"/"}
    end

    # Get primary key field name.
    #
    # Gets the name of the property in the entity which
    # contains the primary key.
    #
    # :rtype: str
    #
    def get_primary_key
        return @payload.get_path("primary_key"){"id"}
    end

    
    # Get entity from data.
    #
    # Get the entity part, based upon the `entity-path` and `path-delimiter`
    # properties in the action configuration.
    #
    # :param data: Object to get entity from.
    # :type data: dict
    #
    # :rtype: dict
    #
    def resolve_entity(data)

        path = self.get_entity_path()
        # When there is no path no traversing is done
        if !path
            return data
        end

=begin
        begin
            return get_path(data, path, delimiter=self.get_path_delimiter())
        rescue Exception => KeyError
            error = "Cannot resolve entity for action: #{self.get_name()}"
            raise ActionSchemaError.new(error)
        end
=end
    end

    # Check if an entity definition exists for the action.
    #
    # :rtype: bool
    #
    def has_entity_definition
        return @payload.path_exists("entity")
    end

    # Get the entity definition as an object.
    #
    # Each entity property is a field name, and the value either the data
    # type as a string or an object with fields.
    #
    # :rtype: object
    #
    def get_entity
        return @payload.get("entity"){{}}
    end

    # Check if any relations exists for the action.
    #
    # :rtype: bool
    #
    def has_relations
        return @payload.path_exists("relation")
    end

    # Get action relations.

    # Each item is an array containins the relation type, the Service name,
    # the Service version and the action name as a string, and the validation
    # setting as a boolean value.
    #
    # :rtype: list
    #
    def get_relations
        return @payload.get_path("relation"){[]}
    end

    # Get the parameters names defined for the action.
    #
    # :rtype: list
    #
    def get_params
        return @params.keys
    end

    
    # Check that a parameter schema exists.
    # 
    # :param name: Parameter name.
    # :type name: str
    #
    # :rtype: bool
    #
    def has_param(name)
        return !@params[name].nil?
    end

    # Get schema for a parameter.
    # 
    # :param name: Parameter name.
    # :type name: str
    #
    # :rtype: ParamSchema
    #
    def get_param_schema(name)
        if !self.has_param(name)
            error = "Cannot resolve schema for parameter: #{name}"
            raise ActionSchemaError.new(error)
        end

        return ParamSchema.new(name, @params[name])
    end

    # Get the file parameter names defined for the action.
    #
    # :rtype: list
    #
    def get_files
        return @files.keys
    end

    # Check that a file parameter schema exists.
    #
    # :param name: File parameter name.
    # :type name: str
    #
    # :rtype: bool
    #
    def has_file(name)
        return !@files[name].nil?
    end

    # Get schema for a file parameter.
    #
    # :param name: File parameter name.
    # :type name: str
    #
    # :rtype: FileSchema
    #
    def get_file_schema(name)
        if !self.has_file(name)
            error = "Cannot resolve schema for file parameter: #{name}"
            raise ActionSchemaError.new(name)
        end

        return FileSchema.new(name, @files[name])
    end

    
    # Get HTTP action schema.
    #
    # :rtype: HttpActionSchema
    #
    def get_http_schema
        return HttpActionSchema.new(@payload.get_path("http"){{}})
    end

end

# HTTP semantics of an action schema in the platform.
#
class HttpActionSchema
 

    def initialize(payload)
        @payload = Payload.new(payload)        
    end

    # Check if the Gateway has access to the action.
    #
    # :rtype: bool
    #
    def is_accessible
        return @payload.get_path("gateway"){true}
    end

    # Get HTTP method for the action.
    #
    # :rtype: str
    #
    def get_method        
        return @payload.get_path("method"){"get"}
    end

    
    # Get URL path for the action.
    # 
    # :rtype: str
    #
    def get_path
        return @payload.get_path("path"){""}
    end

    # Get default location of parameters for the action.
    #
    # :rtype: str
    #
    def get_input
        return @payload.get_path("input"){"query"}
    end

    # Get expected MIME type of the HTTP request body.
    # 
    # Result may contain a comma separated list of MIME types.
    #
    # :rtype: str
    #
    def get_body
        return (@payload.get_path("body"){['text/plain']}).join(",")
    end
end