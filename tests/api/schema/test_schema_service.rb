require_relative '../../../katana/api/schema/param'
require_relative '../../../katana/api/schema/service'
require_relative '../../../katana/payload'

require 'test/unit'

class TestServiceSchema < Test::Unit::TestCase

    def setup
		file = File.read('../../data/schema-service.json')
		@data = JSON.parse(file)
    end

    def teardown
       ## Nothing really
    end

    def test_api_schema_service_defaults
	    service = ServiceSchema.new('foo', '1.0', {})

	    assert service.get_name() == 'foo'
	    assert service.get_version() == '1.0'
	    assert !service.has_file_server()
	    assert service.get_actions() == []
	    assert !service.has_action('bar')

	    # By default there are no action schemas because payload is empty
	    # with pytest.raises(ServiceSchemaError)
	    #     service.get_action_schema('bar')
	    # end

	    http_schema = service.get_http_schema()
	    assert http_schema.is_a? HttpServiceSchema
	    assert http_schema.is_accessible()
	    assert http_schema.get_base_path() == ''
	end

	def test_api_schema_service
	    payload = Payload.new(@data)
	    service = ServiceSchema.new('foo', '1.0', @data)

	    assert service.get_name() == 'foo'
	    assert service.get_version() == '1.0'
	    assert service.has_file_server()
	    assert (service.get_actions().sort_by { |key| key.downcase }) == ['defaults', 'foo']
	    assert service.has_action('foo')
	    assert service.has_action('defaults')

	    # Check action schema
	    action_schema = service.get_action_schema('foo')
	    assert action_schema.is_a? ActionSchema

	    # Check HTTP schema
	    http_schema = service.get_http_schema()
	    assert http_schema.is_a? HttpServiceSchema
	    assert !http_schema.is_accessible()
	    assert http_schema.get_base_path() == payload.get_path('http','base_path')	
	end

end