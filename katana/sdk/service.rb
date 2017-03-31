
require_relative '../service'
require_relative 'component'
require_relative 'runner'

# KATANA SDK Service component.
#
class Service < Component

	def initialize (*args)
		super
		help = "Service component action to process application logic"
		runner(ComponentRunner.new(self, ServiceServer.new, help, *args))
	end

	# Set a callback for an action.
	#
    # :param name: Service action name.
    # :type name: str
    # :param callback: Callback to handle action calls.
    # :type callback: callable
    #
    def action(name, callback)
        @callbacks[name] = callback
    end

end