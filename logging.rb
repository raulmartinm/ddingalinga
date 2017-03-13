require 'logger'
require_relative 'json'

class Loggging
  def self.log
    if @logger.nil?
      @logger = Logger.new STDOUT
      @logger.level = Logger::INFO      
      # HELP: http://apidock.com/ruby/DateTime/strftime
      @logger.datetime_format = '%Y-%m-%dT%H:%M:%S.%L+00:00 '
    end
    @logger
  end
end

# Convert a value to a string.
# 
# :param value: A value to log.
# :type value: object
# :param max_chars: Optional maximum number of characters to return.
# :type max_chars: int
# 
# :rtype: str
def value_to_log_string(value, max_chars=100000)

	if value == nil
		output = 'NULL'
	elsif !!value == value
		output =  if value == true ? 'TRUE' : 'FALSE'
	elsif value.is_a? String
		output = value
    elsif value.is_a? Hash || value.is_a? Array
		output = serialize(value)
    else
        output = value.inspect

    return output.length >  max_chars ? output[0,max_chars] : output 
end