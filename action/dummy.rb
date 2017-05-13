require_relative '../katana/sdk/service'

#
# Step 1
#     ruby dummy.rb --name dummy --version 1.0.0 --framework-version 1.0.14 --component service --tcp 7001  --var "workers=5" --disable-compact-names true --debug
# Step 2
#     ./katana service action --standalone --config action-dummy-service-ruby.xml --disable-compact-names --debug --timeout 100 --name dummy --parameter "id=Katana"
#  error:
#     ./katana service action --standalone --config action-dummy-service-ruby-2.xml --disable-compact-names --debug --timeout 100 --name dummy2 --parameter "id=Katana" 


=begin
	
./katana service action --help
Usage: katana service action [OPTIONS]

  Execute a Service action.

Options:
  -c, --config PATH            Path to configuration file.  [required]
  -d, --disable-compact-names  Use full property names instead of compact in
                               payloads.
  -D, --debug                  Enable debug logs.
  -n, --name TEXT              Name of the action.  [required]
  -p, --parameter TEXT         Action parameters. Multiple parameters are
                               supported.
  -s, --silent                 Disable log messages.
  -S, --standalone             Bypass userland source file execution.
  -t, --timeout FLOAT          Action execution timeout in seconds.
  --help                       Show this message and exit.

	
=end  
def bootstrap(action)
	id = action.get_param("id")	
  action.set_entity({"echo" => "Hello #{id.get_value()}"})
  # action.set_entity( "Hello #{id.get_value()}") # Error TypeError not valid
	return action
end

service = Service.new *ARGV
service.action("dummy",method(:bootstrap))
service.run()



=begin
def read_handler(action)
    user_id = action.get_param('id').get_value()

    # Users read action returns a single user entity
    action.set_entity({
        'id': user_id,
        'name': 'foobar',
        'first_name': 'Foo',
        'last_name': 'Bar',
    })
    return action
end

service = Service.new *ARGV
service.action("read", method(:read_handler))
service.run()
=end