
require_relative '../logging'

##
# Parameter class for API.

# A Param object represents a parameter received for an action in a call
# to a Service component.

class Param

	# Supported parameter types
	TYPE_NULL = 'null'
	TYPE_BOOLEAN = 'boolean'
	TYPE_INTEGER = 'integer'
	TYPE_FLOAT = 'float'
	TYPE_ARRAY = 'array'
	TYPE_OBJECT = 'object'
	TYPE_STRING = 'string'


	# Supported parameter locations
	LOC_PATH = 'path'
	LOC_QUERY = 'query'
	LOC_FORM = 'form-data'
	LOC_HEADER = 'header'
	LOC_BODY = 'body'
	LOCATIONS  = [LOC_PATH, LOC_QUERY, LOC_HEADER, LOC_BODY]

	def initialize(location, name, value = '', type = nil, exists=false)
		if not LOCATIONS.include? location
          raise TypeError.new("Unknown location value")
        end

		@location = location 	# The location of the parameter in the request, which MAY be "path", "query", "form-data", "header" or "body"
		@name = name			# The name of the parameter 
		@value = value			# The value of the variable, which MAY be converted from the configuration based on the given type value, or null if the variable for the given name does not exist
		@type = type 			# The data type of the variable, which MAY be "null", "boolean", "integer", "float", "string", "array" or "object"
		@exists = exists 		# Determines if the parameter was provided in the request
	end

	# Get location where parameter was defined.
	#
	# rtype: str
	#
	def get_location
		return @location
	end

	# Get aprameter name.
	#
	# rtype: str
	#
	def get_name
		return @name
	end
	
	# Get parameter data type.
	#
	# rtype: str
	#
	def get_type
		return @type
	end

	# Get parameter value.
	#
	# Value is returned using the parameter data type for casting.
	# returns: The parameter value.
    # rtype: mixed
	#
	def get_value
		return @value
		# error_msg = 'Param "#{@name}" value is not a #{@type}'
		# error_msg1 = 'Param "%s" value is not a %s' % [@name,@type]
		# Loggging.log.debug error_msg1

		#  PHYTON IMPLEMENTATION
 		# name = self.get_name()
        # type_ = self.get_type()
        # error_msg = 'Param "{}" value is not a {}'.format(name, type_)
        # try:
        #     value = self.__value
        #     if type_ == 'string':
        #         value = '"{}"'.format(value)

        #     value = json.deserialize(value)
        # except:
        #     LOG.error('Param "%s" is not %s: %s', name, type_, value)
        #     raise TypeError(error_msg)

        # if not isinstance(value, TYPE_CLASSES[type_]):
        #     raise TypeError(error_msg)

        # return value
	end

	# Check if parameter exists.
	def exists
		return @exists
	end

	def to_s
		"(location:#@location,\n
		name:#@name,\n
		value:#@value,\n
		type:#@type,\n
		exists:#@exists)"
	end
end