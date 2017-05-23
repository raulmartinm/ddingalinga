=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative 'base'
require_relative 'param'
require_relative '../logging'
require_relative '../errors'


# Base error class for API Action errors.
#
class ActionError < ApiError 
 
    def initialize(service, version, action)
        super
        @service = service
        @version = version
        @action = action
        @service_string = "'#{service}' (#{version})"
    end
end


# Action API class for Service component.
#
class Action < Api

	def initialize(action, params, transport, *args)
		super(*args) # (component, path, name, version, framework_version, variables=nil, debug=false)
		@action = action
		@params = Hash[params.map { |p| [p["name"], p] }]
		@transport = transport
        @gateway = transport.get_data("meta","gateway")

        service = self.get_name()
        version = self.get_version()
        action_name = self.get_action_name()

        # Get files for current service, version and action
=begin
        path = 'files|{}|{}|{}|{}'.format(
            self.__gateway[1],
            nomap(service),
            version,
            nomap(action_name),
            )
        self.__files = transport.get(path, default={}, delimiter='|')
=end
        # Get schema for current action
        begin
            @schema = self.get_service_schema(service, version)
            @action_schema = @schema.get_action_schema(action_name)
        rescue ApiError => exc
            # When schema for current service can't be resolved it means action
            # is run from CLI and because of that there are no mappings to
            # resolve schemas.
            @schema = nil
            @action_schema = nil
        end
        
        # Init return value with a default when action supports it
=begin
        self.__return_value = kwargs.get('return_value', Payload())
        if not self.__action_schema:
            self.__return_value.set('return', None)
        elif self.__action_schema.has_return():
            # When return value is supported set a default value by type
            rtype = self.__action_schema.get_return_type()
            self.__return_value.set('return', DEFAULT_RETURN_VALUES.get(rtype))
=end
	end

    # Determines if the current service is the origin of the request.
    # 
    # :rtype: bool
    #
    def is_origin
        origin = @transport.get_data("meta","origin")
        # compare two arrays with intersection
        return (origin & [@name,@version,@action]).empty?
    end

    # Get the name of the action.
    #
    # :rtype: str
    #    
    def get_action_name
        return @action
    end

    # Sets a user land property.
    # 
    # Sets a userland property in the transport with the given
    # name and value.
    # 
    # :param name: The property name.
    # :type name: str
    # :param value: The property value.
    # :type value: str
    # 
    # :raises: TypeError
    # 
    # :rtype: Action

    def set_property(name, value)
        if !(value.is_a? String)
            raise TypeError.new("Value is not a string'")
        end
        @transport.set_vale("meta","properties",name,value)
        return self
    end

    # Check if a parameter exists.
    # 
    # :param name: The parameter name.
    # :type name: str
    # 
    # :rtype: bool
    # 
    def has_param(name)        
        return (@params.has_key? name)
    end

    # Get an action parameter.
    #
    # :param name: The parameter name.
    # :type name: str
    #
    # :rtype: `Param`
    #
    def get_param(name)

        if !self.has_param(name)
            return Param(name)
        end

        Loggging.log.debug "action get_param: name = #{name}"
        Loggging.log.debug "action get_param: value= #{@params[name]['value']}"
        Loggging.log.debug "action get_param: type = #{@params[name]['type']}"
        return Param.new(
            name,
            @params[name]["value"],
            @params[name]["type"],
            true
        )
    end

    # Get all action parameters.
    #
    # :rtype: list
    #
    def get_params

        return @params.map { |p| 
            Param.new(
                name,
                p[name]["value"],
                p[name]["type"],
                true
            )
        }
    end


    # Creates a new parameter object.
    # 
    # Creates an instance of Param with the given name, and optionally
    # the value and data type. If the value is not provided then
    # an empty string is assumed. If the data type is not defined then
    # "string" is assumed.
    # 
    # Valid data types are "null", "boolean", "integer", "float", "string",
    # "array" and "object".
    # 
    # :param name: The parameter name.
    # :type name: str
    # :param value: The parameter value.
    # :type value: mixed
    # :param type: The data type of the value.
    # :type type: str
    # 
    # :raises: TypeError
    # 
    # :rtype: Param
    # 
    def new_param(name, value=nil, type=nil)

        if type and Param.resolve_type(value) != type
            raise TypeError.new("Incorrect data type given for parameter value")
        else
            type = Param.resolve_type(value)
        end

        return Param.new(name, value, type, true)
    end

=begin

    # Check if a file was provided for the action.
    # 
    # :param name: File name.
    # :type name: str
    # 
    # :rtype: bool
    # 
    def has_file(name)
        return (@files.has_key? name)
    end

    # Get a file with a given name.
    #
    # :param name: File name.
    # :type name: str
    #
    # :rtype: `File`
    #
    def get_file(name)

        if self.has_file(name)
            return payload_to_file(name, @files[name])
        else
            return File(name, '')
        end
    end

    # Get all action files.
    #
    # :rtype: list
    # 
    def get_files
        # TODO
        # return @files.map { |f| payload_to_file(name,payload) }
        

        files = []
        for name, payload in @files.items()
            files.append(payload_to_file(name, payload))
        end

        return files
    end

    # Create a new file.
    # 
    # :param name: File name.
    # :type name: str
    # :param path: File path.
    # :type path: str
    # :param mime: Optional file mime type.
    # :type mime: str
    # 
    # :rtype: `File`
    # 
    def new_file(name, path, mime=nil)
        return File.new(name, path, mime)
    end
=end


=begin
    
    def set_return(self, value):
        """Sets the value to be returned as "return value".

        Supported value types: bool, int, float, str, list, dict and None.

        :param value: A supported return value.
        :type value: object

        :raises: UndefinedReturnValueError
        :raises: ReturnTypeError

        :rtype: Action

        """

        service = self.get_name()
        version = self.get_version()
        action = self.get_action_name()

        # When runnong from CLI allow any return values
        if not self.__action_schema:
            self.__return_value.set('return', value)
            return self

        if not self.__action_schema.has_return():
            raise UndefinedReturnValueError(service, version, action)

        # Check that value type matches return type
        if value is not None:
            rtype = self.__action_schema.get_return_type()
            if not isinstance(value, RETURN_TYPES[rtype]):
                raise ReturnTypeError(service, version, action)

        self.__return_value.set('return', value)
        return self

=end


    # Sets an object as the entity to be returned by the action.
    #
    # Entity is validated when validation is enabled for an entity
    # in the Service config file.
    #
    # :param entity: The entity object.
    # :type entity: dict
    #
    # :raises: TypeError
    #
    # :rtype: Action   
    #
    def set_entity(entity)

        Loggging.log.debug "action set_entity: name = #{self.get_name}, version = #{self.get_version}, action_name = #{self.get_action_name}"
        if !(entity.is_a? Hash)
            raise TypeError.new("Entity must be an dict o hash")
        end
		@transport.push_value("data",
            @gateway[1],
            self.get_name, 
            self.get_version, 
            self.get_action_name, 
            entity)
        return self
    end

    # Sets the collection data.
    #
    # Sets a list as the collection of entities to be returned by the action.
    #
    # :param collection: The collection list.
    # :type collection: list   
    def set_collection(collection)
        Loggging.log.debug "action set_collection: name = #{self.get_name}, version = #{self.get_version}, action_name = #{self.get_action_name}"
        if !(collection.is_a? Array)
            raise TypeError.new("Collection must be a list or array")
        end
        collection.each do |entity|
            if !(entity.is_a? Hash)
                raise TypeError.new("Entity must be an dict o hash")
            end
        end
		@transport.push_value("data",
            @gateway[1],
            self.get_name,
            self.get_version,
            self.get_action_name,
            collection)
        return self
    end

    # Adds an error for the current Service.
    # 
    # Adds an error object to the Transport with the specified message.
    # If the code is not set then 0 is assumed. If the status is not
    # set then 500 Internal Server Error is assumed.
    # 
    # :param message: The error message.
    # :type message: str
    # :param code: The error code.
    # :type code: int
    # :param status: The HTTP status message.
    # :type status: str
    # 
    # :rtype: Action
    # 
    def error(message, code=nil, status=nil)
        Loggging.log.debug "action set_error: name = #{self.get_name}, version = #{self.get_version}, action_name = #{self.get_action_name}"
        @transport.set_value("errors",
            @gateway[1],
            self.get_name,
            self.get_version,            
            ErrorPayload.new.int(message, code, status))
        return self
    end

end