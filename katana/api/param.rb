=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
=end

require_relative '../logging'

##
# Parameter class for API.
#
# A Param object represents a parameter received for an action in a call
# to a Service component.
#
class Param

=begin

	https://en.wikibooks.org/wiki/Ruby_Programming/Data_types

	h = {"hash?" => "yep, it\'s a hash!", "the answer to everything" => 42, :linux => "fun for coders."}
	1.-  puts "Stringy string McString!".class
	2.-  puts 1.class
	3.-  puts 1.class.superclass
	4.-  puts 1.class.superclass.superclass
	5.-  puts 4.3.class
	6.-  puts 4.3.class.superclass
	7.-  puts nil.class
	8.-  puts h.class
	9.-  puts :symbol.class
	10.- puts [].class
	11.- puts (1..8).class
	12.- puts flase.class
	13.- puts true.class

	1.-  String
	2.-  Fixnum
	3.-  Integer
	4.-  Numeric
	5.-  Float
	6.-  Numeric
	7.-  NilClass
	8.-  Hash
	9.-  Symbol
	10.- Array
	11.- Range
	12.- FalseClass
	13.- TrueClass

=end

	# Supported parameter types
	TYPE_NULL = "null"
	TYPE_BOOLEAN = "boolean"
	TYPE_INTEGER = "integer"
	TYPE_FLOAT = "float"
	TYPE_ARRAY = "array"
	TYPE_OBJECT = "object"
	TYPE_STRING = "string"

	# Type data in ruby
	NAME_CLASS_NIL = "NilClass"
	NAME_CLASS_TRUE = "TrueClass"
	NAME_CLASS_FALSE = "FalseClass"
	NAME_CLASS_STRING = "String"
	NAME_CLASS_NUMERIC = "Numeric"
	NAME_CLASS_FIXNUM = "Fixnum"
	NAME_CLASS_INTEGER = "Integer"
	NAME_CLASS_FLOAT = "Float"
	NAME_CLASS_ARRAY = "Array"
	NAME_CLASS_HASH = "Hash"
	NAME_CLASS_RANGE = "Range"
	NAME_CLASS_SYMBOL = "Symbol"
	NAME_CLASS_OBJECT = "Object"

	# Mapping native types to schema types.
	TYPE_CLASSES = {
		NAME_CLASS_NIL => TYPE_NULL,
		NAME_CLASS_TRUE => TYPE_BOOLEAN,
		NAME_CLASS_FALSE => TYPE_BOOLEAN,
		NAME_CLASS_STRING => TYPE_STRING,
		NAME_CLASS_FIXNUM => TYPE_INTEGER,
		NAME_CLASS_INTEGER => TYPE_INTEGER,
		NAME_CLASS_FLOAT => TYPE_FLOAT,
		NAME_CLASS_ARRAY => TYPE_ARRAY,
		NAME_CLASS_RANGE => TYPE_ARRAY,
		NAME_CLASS_HASH => TYPE_OBJECT,
	}

	def initialize(name, value="", type=TYPE_STRING, exists=false)		
		@name = name
		@value = value
		@type = type || resolve_type(value) 
		@exists = exists
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
	end

	# Check if parameter exists.
	def exists
		return @exists
	end

	# Converts native types to schema types.
	#
    # :param value: The value to analyze.
    # :type value: mixed
    #
    # :rtype: str
    #
	def resolve_type(value)
		# Resolve standard mapped ruby types
        return TYPE_CLASSES[value.class.name] || TYPE_OBJECT
    end


	def to_s
		"(location:#@location,\n
		name:#@name,\n
		value:#@value,\n
		type:#@type,\n
		exists:#@exists)"
	end
end