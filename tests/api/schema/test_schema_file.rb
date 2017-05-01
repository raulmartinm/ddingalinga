require_relative '../../../katana/api/schema/file'
require_relative '../../../katana/payload'
require 'json'
require 'test/unit'

class TestFileSchema < Test::Unit::TestCase

    def setup
       file = File.read('../../data/schema-file.json')
       @data = JSON.parse(file)
    end

    def teardown
       ## Nothing really
    end

	def test_api_schema_file
	    # Check file schema defaults
	    schema = FileSchema.new('foo', {})
	    assert schema.get_name == 'foo'
	    assert schema.get_mime == 'text/plain'
	    assert !schema.is_required
	    assert schema.get_max == 10000
	    assert !schema.is_exclusive_max
	    assert schema.get_min == 0
	    assert !schema.is_exclusive_min

	    http_schema = schema.get_http_schema
	    assert http_schema.is_a? HttpFileSchema
	    assert http_schema.is_accessible
	    assert http_schema.get_param == schema.get_name

	    # Create a payload with file schema data
	    payload = Payload.new(@data)

	    # Check file schema with values
	    schema = FileSchema.new('foo', @data)
	    assert schema.get_name == 'foo'
	    assert schema.get_mime == payload.get_path('mime')
	    assert schema.is_required
	    assert schema.get_max == payload.get_path('max')
	    assert schema.is_exclusive_max
	    assert schema.get_min == payload.get_path('min')
	    assert schema.is_exclusive_min

	    http_schema = schema.get_http_schema
	    assert http_schema.is_a? HttpFileSchema
	    assert !http_schema.is_accessible
	    assert http_schema.get_param == payload.get_path('http','param')
	end

end