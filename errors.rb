
# Base exception for KATANA errors.
class KatanaError < StandardError
end

# Error for request timeouts.
class RequestTimeoutError < KatanaError
	def initialize(msg="Request timeout")
		super
	end
end

# Error for payload expiration.
class PayloadExpired < KatanaError
  attr_reader :offset
  def initialize(offset="")
    @offset = offset
    super("Payload expired #{@offset.round(3)} seconds ago")
  end
end


# Error for invalid payloads.
class PayloadError < KatanaError
  attr_reader :status, :code
  def initialize(message=nil, status=nil, code=nil)
  	super(message || "Payload error")
    @status = status || "500 Internal Server Error"
    @code = code    
  end
end