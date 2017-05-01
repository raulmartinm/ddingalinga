require_relative '../../../katana/api/schema/action'
require_relative '../../../katana/api/schema/param'
require_relative '../../../katana/api/schema/file'
require_relative '../../../katana/payload'
require 'json'
require 'test/unit'

class TestActionSchema < Test::Unit::TestCase

    def setup
       file = File.read('../../data/schema-service.json')
       @data = JSON.parse(file)
    end

    def teardown
       ## Nothing really
    end

	def test_api_schema_action_defaults
	    action = ActionSchema.new('foo', {})

	    assert action.get_name == 'foo'
	    assert !action.is_deprecated
	    assert !action.is_collection
	    assert action.get_entity_path == ''
	    assert action.get_path_delimiter == '/'
	    assert action.get_primary_key == 'id'
	    assert action.resolve_entity({}) == {}
	    assert !action.has_entity_definition
	    assert action.get_entity == {}
	    assert !action.has_relations
	    assert action.get_relations == []
	    assert !action.has_call('foo')
	    assert !action.has_calls
	    assert action.get_calls == []
	    assert !action.has_defer_call('foo')
	    assert !action.has_defer_calls
	    assert action.get_defer_calls == []
	    assert !action.has_remote_call('ktp://87.65.43.21:4321')
	    assert !action.has_remote_calls
	    assert action.get_remote_calls == []
	    assert !action.has_return
	    assert action.get_return_type == ''
	    assert action.get_params == []
	    assert !action.has_param('foo')

	    # with pytest.raises(ActionSchemaError):
	    #    action.get_param_schema('foo')

	    assert action.get_files == []
	    assert !action.has_file('foo')

	    # with pytest.raises(ActionSchemaError):
	    #    action.get_file_schema('foo')

	    http_schema = action.get_http_schema
	    assert http_schema.is_a? HttpActionSchema
	    assert http_schema.is_accessible
	    assert http_schema.get_method == 'get'
	    assert http_schema.get_path == ''
	    assert http_schema.get_input == 'query'
	    assert http_schema.get_body == 'text/plain'
    end

end
