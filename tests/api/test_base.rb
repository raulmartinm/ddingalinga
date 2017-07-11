require_relative '../../katana/api/base'

require 'test/unit'

class TestBase < Test::Unit::TestCase

    def setup    	
    end

    def teardown
    end

    def test_api_base
 		values = {
 			'component'	 		=> nil,
			'path' 				=> '/path/to/file.py',
			'name' 				=> 'dummy',
			'version'			=> '1.0',
			'framework_version' => '1.0.0',
		}

		# .-- initialize(component, path, name, version, framework_version, variables=nil, compact_names=false, debug=false) --
		api = Api.new(values['component'], values['path'], values['name'], values['version'], values['framework_version'])

		# Check defaults
    	assert !api.is_debug()
    	assert api.get_variables() == {}

    	# Check values
    	assert api.get_framework_version() == values['framework_version']
    	assert api.get_path() == values['path']
    	assert api.get_name() == values['name']
    	assert api.get_version() == values['version']


		# Check other values that were defaults
    	variables = {'foo' => 'bar'}
    	api = Api.new(values['component'], values['path'], values['name'], values['version'], values['framework_version'], variables, false, true)
    	assert api.is_debug()
    	assert api.get_variables() == variables
    	assert api.get_variable('foo') == variables['foo']

    end

=begin
	def test_api_base_get_services()
	    values = {
	        'component'	 			=> nil,
	        'path'					=> '/path/to/file.py',
	        'name'					=> 'dummy',
	        'version'				=> '1.0',
	        'framework_version'		=> '1.0.0',
	    }
	    api = Api.new(values['component'], values['path'], values['name'], values['version'], values['framework_version'])

	    # Get services is empty when there are no service mappings
	    assert api.get_services() == []

	    # Add data to registry
	    svc_name = 'foo'
	    svc_version = '1.0.0'
	    registry.update_registry({svc_name: {svc_version: {}}})

	    # Get services must return service name and version
	    assert api.get_services() == [{'name' => svc_name, 'version' => svc_version}]
	end
=end

end