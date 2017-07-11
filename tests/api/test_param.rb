require_relative '../../katana/api/param'

require 'test/unit'

class TestParam < Test::Unit::TestCase

    def setup
    	@TYPE_NULL = "null"
		@TYPE_BOOLEAN = "boolean"
		@TYPE_INTEGER = "integer"
		@TYPE_FLOAT = "float"
		@TYPE_ARRAY = "array"
		@TYPE_OBJECT = "object"
		@TYPE_STRING = "string"
    end

    def teardown
    end

	def test_api_param()
	    # Check empty param creation
	    param = Param.new('foo')
	    assert param.get_name() == 'foo'
	    assert param.get_value() == ''
	    assert param.get_type() == @TYPE_STRING
	    assert !param.exists()

	    # Create a parameter with an unknown type
	    param = Param.new('foo', 42, 'weird')
	    assert param.get_type() != @TYPE_STRING

	    # Check param creation
	    param = Param.new('foo', 42, nil)
	    assert param.get_name() == 'foo'
	    assert param.get_value() == 42
	    assert param.get_type() == @TYPE_INTEGER	    

	    # Check param creation
	    param = Param.new('foo', 42, @TYPE_INTEGER, true)
	    assert param.get_name() == 'foo'
	    assert param.get_value() == 42
	    assert param.get_type() == @TYPE_INTEGER
	    assert param.exists()
	end

	def test_api_param_resolve_type
		param = Param.new('foo')
        cases = {
            nil  => @TYPE_NULL,
            true => @TYPE_BOOLEAN,
            0    => @TYPE_INTEGER,
            0.0  => @TYPE_FLOAT,
            []   => @TYPE_ARRAY,
            ''   => @TYPE_STRING,
            {} 	=>  @TYPE_OBJECT,            
        }
        cases.each_pair do |key, value|
           assert param.resolve_type(key) == value
        end

    end

end