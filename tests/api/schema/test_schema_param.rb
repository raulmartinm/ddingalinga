require_relative '../../../katana/api/schema/param'
require_relative '../../../katana/payload'
require 'json'
require 'test/unit'

class TestParamSchema < Test::Unit::TestCase

    def setup
       file = File.read('../../data/schema-param.json')
       @data = JSON.parse(file)
    end

    def teardown
       ## Nothing really
    end

	def test_api_schema_param

	    # Check param schema defaults
	    schema = ParamSchema.new('foo', {})
	    assert schema.get_name == 'foo'
	    assert schema.get_type == 'string'
	    assert schema.get_format == ''
	    assert schema.get_array_format == 'csv'
	    assert schema.get_pattern == ''
	    assert !schema.allow_empty
	    assert !schema.has_default_value
	    assert schema.get_default_value == ''
	    assert !schema.is_required
	    assert schema.get_items == {}
	    assert schema.get_max == 10000
	    assert !schema.is_exclusive_max
	    assert schema.get_min == -10001
	    assert !schema.is_exclusive_min
	    assert schema.get_max_length == -1
	    assert schema.get_min_length == -1
	    assert schema.get_max_items == -1
	    assert schema.get_min_items == -1
	    assert !schema.has_unique_items
	    assert schema.get_enum == []
	    assert schema.get_multiple_of == -1

	    http_schema = schema.get_http_schema
	    assert http_schema.is_a? HttpParamSchema
	    assert http_schema.is_accessible
	    assert http_schema.get_input == 'query'
	    assert http_schema.get_param == schema.get_name


	    # Create a payload with param schema data
	    payload = Payload.new(@data)

	    # Check param schema with values
	    schema = ParamSchema.new('foo', @data)
	    assert schema.get_name == 'foo'
	    assert schema.get_type == payload.get_path('type')
	    assert schema.get_format == payload.get_path('format')
	    assert schema.get_array_format == payload.get_path('array_format')
	    assert schema.get_pattern == payload.get_path('pattern')
	    assert schema.allow_empty
	    assert schema.has_default_value
	    assert schema.get_default_value == payload.get_path('default_value')
	    assert schema.is_required
	    assert schema.get_items == payload.get_path('items')
	    assert schema.get_max == payload.get_path('max')
	    assert schema.is_exclusive_max
	    assert schema.get_min == payload.get_path('min')
	    assert schema.is_exclusive_min
	    assert schema.get_max_length == payload.get_path('max_length')
	    assert schema.get_min_length == payload.get_path('min_length')
	    assert schema.get_max_items == payload.get_path('max_items')
	    assert schema.get_min_items == payload.get_path('min_items')
	    assert schema.has_unique_items
	    assert schema.get_enum == payload.get_path('enum')
	    assert schema.get_multiple_of == payload.get_path('multiple_of')

	    http_schema = schema.get_http_schema
	    assert http_schema.is_a? HttpParamSchema
	    assert !http_schema.is_accessible
	    assert http_schema.get_input == payload.get_path('http','input')
	    assert http_schema.get_param == payload.get_path('http','param')

	end

end