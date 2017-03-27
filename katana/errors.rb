=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
=end

# Base exception for KATANA errors.
#
class KatanaError < StandardError
end

# Error for request timeouts.
#
class RequestTimeoutError < KatanaError
	def initialize(msg="Request timeout")
		super
	end
end

# Error for payload expiration.
#
class PayloadExpired < KatanaError
  attr_reader :offset
  def initialize(offset="")
    @offset = offset
    super("Payload expired #{@offset.round(3)} seconds ago")
  end
end


# Error for invalid payloads.
#
class PayloadError < KatanaError
  attr_reader :status, :code
  def initialize(message=nil, status=nil, code=nil)
  	super(message || "Payload error")
    @status = status || "500 Internal Server Error"
    @code = code    
  end
end