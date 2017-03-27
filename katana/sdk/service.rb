
require_relative '../service'
require_relative 'component'
require_relative 'runner'

# KATANA SDK Service component.
#
class Service < Component

	def initialize (*args)
		runner(ComponentRunner.new(ActionWorker.new, *args))
	end

	def run_action(callback)
        run(callback)
    end
end