=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

# HTTP response class.
#
class HttpResponse

    def initialize(status_code, status_text, protocol_version = "1.1", body = "", headers = {})
        self.set_status(status_code, status_text)
        self.set_protocol_version(protocol_version)
        self.set_body(body)
        @headers = {}

=begin
        # Set response headers
        headers = headers
        if !headers.nil?
            
            for name, value in headers:
                self.set_header(name, value)
            end
        end
=end
    end

    # Determine if the response uses the given HTTP version.
    # 
    # :param version: The HTTP version.
    # :type version: str
    #
    # :rtype: bool
    #
    def is_protocol_version(version)
        return @protocol_version == version
    end

	# Get the HTTP version.
	#
    # :rtype: str
    #
    def get_protocol_version
        return @protocol_version
     end

    
    # Set the HTTP version to the given protocol version.
    #
    # Sets the HTTP version of the response to the specified
    # protocol version.
    #
    # :param version: The HTTP version.
    # :type version: str
    #
    # :rtype: HttpResponse
    #
    def set_protocol_version(version)
        @protocol_version = version || "1.1"
    end

    # Determine if the response uses the given status.
    #
    # :param status: The HTTP status.
    # :type status: str
    #
    # :rtype: bool
    #
    def is_status(status)
        return @status == status
    end

    # Get the HTTP status.
    # 
    # :rtype: str
    #
    def get_status
        return @status
    end

    
    # Get HTTP status code.
	#
    # :rtype: int
    #
    def get_status_code
        return @status_code
    end

    
    # Get HTTP status text.
	#
    # :rtype: str
    #
    def get_status_text
        return @status_text
    end

    
    # Set the HTTP status to the given status.
    # 
    # Sets the status of the response to the specified
    # status code and text.
    #
    # :param code: The HTTP status code.
    # :type code: int
    # :param text: The HTTP status text.
    # :type text: str
    #
    # :rtype: HttpResponse
    #
    def set_status(code, text)
        @status_code = code
        @status_text = text
        @status = "#{code} #{text}"
    end

    # Determines if the HTTP header is defined.
    # 
    # :param name: The HTTP header name.
    # :type name: str
    # 
    # :rtype: bool
    #
    def has_header(name)
        return !@headers[name].nil?
    end

    # Get an HTTP header.
    #
    # :param name: The HTTP header.
    # :type name: str
    #
    # :rtype: str
    #
    def get_header(name)
=begin
    
        values = self.__headers.get(name)
        if not values:
            return ''

        # Get first header value
        return values[0]   
=end        
        return @headers[name]
    end

    
	# Get all HTTP header.
	#
    # :rtype: `MultiDict`
    #
    def get_headers
        return @headers
    end

    
	# Set a HTTP with the given name and value.
	#
    # Sets a header in the HTTP response with the specified name and value.
    #
    # :param name: The HTTP header.
    # :type name: str
    # :param value: The header value.
    # :type value: str
    #
    # :rtype: HttpResponse
    #
    def set_header(name, value)
        @headers[name] = value
    end

    # Determines if the response has content.
    #
    # Returns True if the HTTP response body has content, otherwise False.
    #
    # :rtype: bool
    #
    def has_body
        return @body != ""
    end

    # Gets the response body.
    #
    # :returns: The HTTP response body.
    # :rtype: str
    #
    def get_body
        return @body
    end

	# Set the content of the HTTP response.
	#
    # Sets the content of the body of the HTTP response with
    # the specified content.
    #
    # :param content: The content for the HTTP response body.
    # :type content: str
    #
    # :rtype: HttpResponse
    #
    def set_body(content=nil)
        @body = content || ""
    end

end