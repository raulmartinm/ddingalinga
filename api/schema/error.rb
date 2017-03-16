=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative '../../errors'

# Base error class for Service schemas.
#
class ServiceSchemaError < KatanaError
	def initialize()
		super
	end
end