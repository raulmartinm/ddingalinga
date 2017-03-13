require_relative 'base'
require_relative 'param'
require_relative '../logging'

# Action API class for Service component.
class Action < Api

	def initialize(action, params, transport, *args)
		super(*args) # (path, name, version, platform_version, variables=nil, debug=false)
		@action = action
		@params = params
		@transport = transport
	end

	# Determines if the current service is the origin of the request.
	# 
    # :rtype: bool
	def is_origin
		origin = @transport.get_path("meta","origin")
		return (origin.get_path("name") == @name && origin.get_path("version") == @version)
	end

	# Get the name of the action.
	#
	# :rtype: str
	def get_action_name
		return @action
	end

	# Sets a user land property.
	#
	# sets a userland property in the transport with the given
    # name and value.
	#
    # :param name: The property name.
    # :type name: str
    # :param value: The property value.
    # :type value: str
	#
    # :rtype: bool
	def set_property(name, value)
		@transport.deep_nest("meta","properties",name,value)
	end

	# Gets a parameter passed to the action.
	#
    # Returns a Param object containing the parameter for the given location
    # and name.
    #
    # Valid location values are "path", "query", "form-data", "header"
    # and "body".
    #
    # :param location: The parameter location.
    # :type location: str
    # :param name: The parameter name.
    # :type name: str
    #
    # :rtype: `Param`
    def get_param(location, name)
        Loggging.log.debug "action get_param: location = #{location}, name = #{name}"
        Loggging.log.debug "action get_param: value = #{@params.get_param(location,name,"value")}"
        Loggging.log.debug "action get_param: type = #{@params.get_param(location,name,"type")}"
        Loggging.log.debug "action get_param: exists = #{((@params.get_param(location,name,nil){nil}))!=nil}"
        return Param.new(
            location,
            name,
            @params.get_param(location,name,"value"),
            @params.get_param(location,name,"type"),
            (@params.get_param(location,name,nil){nil})!=nil
        )
    end

    def get_path_param(name)
        return get_param("path", name)
    end

    def get_query_param(name)
        return get_param("query", name)
    end

    def get_form_param(name)
        return get_param("form", name)
    end

    def get_header_param(name)
        return get_param("header", name)
    end

    def get_body_param(name)
        return get_param("body", name)
    end

    # Creates a new parameter object.

    # Creates an instance of Param with the given location and name, and
    # optionally the value and data type. If the value is not provided then
    # an empty string is assumed. If the data type is not defined then
    # "string" is assumed.
	#
    # Valid location values are "path", "query", "form-data", "header"
    # and "body".
	#
    # Valid data types are "null", "boolean", "integer", "float", "string",
    # "array" and "object".
    #
    # :param location: The parameter location.
    # :type location: str
    # :param name: The parameter name.
    # :type name: str
    # :param value: The parameter value.
    # :type value: mixed
    # :param datatype: The data type of the value.
    # :type datatype: str
    #
    # :rtype: `Param`
    def new_param(location, name, value=nil, datatype=nil)
    end


    # Sets the entity data.
    #
    # Sets an object as the entity to be returned by the action.
    #
    #:param entity: The entity object.
    #:type entity: dict    
    #
    def set_entity(entity)
        Loggging.log.debug "action set_entity: name = #{self.get_name}, version = #{self.get_version}, action_name = #{self.get_action_name}"
		@transport.deep_nest("data",self.get_name, self.get_version, self.get_action_name, entity)

        #if not isinstance(entity, dict):
        #    raise TypeError('Entity must be an dict')

        #return self.__transport.push(
        #    'data/{}/{}/{}'.format(
        #        self.get_name(),
        #        self.get_version(),
        #        self.get_action_name(),
        #        ),
        #    entity,
        #    )
    end

    # Sets the collection data.
    #
    # Sets a list as the collection of entities to be returned by the action.
    #
    # :param collection: The collection list.
    # :type collection: list   
    def set_collection(collection)
        Loggging.log.debug "action set_collection: name = #{self.get_name}, version = #{self.get_version}, action_name = #{self.get_action_name}"
		@transport.deep_nest("data",self.get_name, self.get_version, self.get_action_name, collection)

        #if not isinstance(collection, list):
        #    raise TypeError('Collection must be a list')

        #for entity in collection:
        #    if not isinstance(entity, dict):
        #        raise TypeError('Entity must be an dict')

        #return self.__transport.push(
        #    'data/{}/{}/{}'.format(
        #        self.get_name(),
        #        self.get_version(),
        #        self.get_action_name(),
        #        ),
        #    collection,            
        #    )
    end

end