require_relative '../../logging'
require_relative '../../payload'

# Action schema in the platform.
#
class ActionSchema
    

    def initialize(name, payload)
        @name = name
        @payload = Payload(payload)
        @params = @payload.get('params', {})
        @files = @payload.get('files', {})
    end

    # Check if action has been deprecated.
    #
    # :rtype: bool
    def is_deprecated
        # return @payload.get('deprecated', False)
    end

    # Check if the action returns a collection of entities.
    #
    # :rtype: bool
    def is_collection
        # return @payload.get('collection', False)
    end

    # Get action name.
    #
    # :rtype: str
    def get_name
        # return @name
    end

    # Get path to the entity.
    # 
    # :rtype: str
    def get_entity_path
        # return @payload.get('entity_path', '')
    end

    
    # Get delimiter to use for the entity path.
    #
    # :rtype: str
    def get_path_delimiter
        # return @payload.get('path_delimiter', '/')
    end

    # Get primary key field name.
    #
    # Gets the name of the property in the entity which
    # contains the primary key.
    #
    # :rtype: str
    def get_primary_key
        # return @payload.get('primary_key', 'id')
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
    def resolve_entity(data)
=begin
        path = self.get_entity_path()
        # When there is no path no traversing is done
        if not path:
            return data

        try:
            return get_path(data, path, delimiter=self.get_path_delimiter())
        except KeyError:
            error = 'Cannot resolve entity for action: {}'
            raise ActionSchemaError(error.format(self.get_name()))
=end            
    end

    # Check if an entity definition exists for the action.
    #
    # :rtype: bool
    def has_entity_definition
        # return @payload.path_exists('entity')
    end

    # Get the entity definition as an object.
    #
    # Each entity property is a field name, and the value either the data
    # type as a string or an object with fields.
    #
    # :rtype: object
    def get_entity
        # return @payload.get('entity', {})
    end

    # Check if any relations exists for the action.
    #
    # :rtype: bool
    def has_relations
        # return @payload.path_exists('relation')
    end

    # Get action relations.

    # Each item is an array containins the relation type, the Service name,
    # the Service version and the action name as a string, and the validation
    # setting as a boolean value.
    #
    # :rtype: list
    def get_relations
        # return @payload.get('relation', [])
    end

    # Get the parameters names defined for the action.
    #
    # :rtype: list
    def get_params
        # return @params.keys()
    end

    
    # Check that a parameter schema exists.
    # 
    # :param name: Parameter name.
    # :type name: str
    #
    # :rtype: bool
    def has_param(name)
        # return name in @params
    end

    # Get schema for a parameter.
    # 
    # :param name: Parameter name.
    # :type name: str
    #
    # :rtype: ParamSchema
    def get_param_schema(name)
=begin
        if not self.has_param(name):
            error = 'Cannot resolve schema for parameter: {}'
            raise ActionSchemaError(error.format(name))

        return ParamSchema(name, @params[name])
=end
    end

    # Get the file parameter names defined for the action.
    #
    # :rtype: list
    def get_files
        # return @files.keys()
    end

    # Check that a file parameter schema exists.
    #
    # :param name: File parameter name.
    # :type name: str
    #
    # :rtype: bool
    def has_file(name)
        # return name in @files
    end

    # Get schema for a file parameter.
    #
    # :param name: File parameter name.
    # :type name: str
    #
    # :rtype: FileSchema
    def get_file_schema(name)
=begin        
        if not self.has_file(name):
            error = 'Cannot resolve schema for file parameter: {}'
            raise ActionSchemaError(error.format(name))

        return FileSchema(name, @files[name])
=end
    end

    
    # Get HTTP action schema.
    #
    # :rtype: HttpActionSchema
    def get_http_schema
        #return HttpActionSchema(@payload.get('http', {}))
    end

end

# HTTP semantics of an action schema in the platform.
#
class HttpActionSchema
 

    def initialize(payload)
        @payload = Payload(payload)
    end

    # Check if the Gateway has access to the action.
    #
    # :rtype: bool
    def is_accessible
        # return @payload.get('gateway', True)
    end

    # Get HTTP method for the action.
    #
    # :rtype: str
    def get_method        
        # return @payload.get('method', 'get')
    end

    
    # Get URL path for the action.
    # 
    # :rtype: str
    def get_path
        # return @payload.get('path', '')
    end

    # Get default location of parameters for the action.
    #
    # :rtype: str
    def get_input
       # return @payload.get('input', 'query')
    end

    # Get expected MIME type of the HTTP request body.
    # 
    # Result may contain a comma separated list of MIME types.
    #
    # :rtype: str
    def get_body
        # return ','.join(@payload.get('body', ['text/plain']))
    end
end