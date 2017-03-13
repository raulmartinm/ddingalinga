
# HTTP response class.
class HttpResponse

    def initialize(status_code, status_text)
=begin
        self.__headers = MultiDict()
        self.set_status(status_code, status_text)
        self.set_protocol_version(kwargs.get('protocol_version'))
        self.set_body(kwargs.get('body'))

        # Set response headers
        headers = kwargs.get('headers')
        if headers:
            # Headers should be a list of tuples
            if isinstance(headers, dict):
                headers = headers.items()

            for name, value in headers:
                self.set_header(name, value)
=end
    end

    # Determine if the response uses the given HTTP version.
    # 
    # :param version: The HTTP version.
    # :type version: str
    #
    # :rtype: bool
    def is_protocol_version(version)
        # return self.__protocol_version == version
    end

	# Get the HTTP version.
	#
    # :rtype: str
    def get_protocol_version
        # return self.__protocol_version
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
    def set_protocol_version(version)
        #self.__protocol_version = version or '1.1'
        #return self
    end

    # Determine if the response uses the given status.
    #
    # :param status: The HTTP status.
    # :type status: str
    #
    # :rtype: bool
    def is_status(status)
        # return self.__status == status
    end

    # Get the HTTP status.
    # 
    # :rtype: str
    def get_status
        # return self.__status
    end

    
	# Get HTTP status code.
	#
    # :rtype: int
    def get_status_code
        # return self.__status_code
    end

    
	# Get HTTP status text.
	#
    # :rtype: str
    def get_status_text
        #return self.__status_text
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
    def set_status(code, text)
=begin
        self.__status_code = code
        self.__status_text = text
        self.__status = '{} {}'.format(code, text)
        return self
=end
    end

    # Determines if the HTTP header is defined.
    # 
    # :param name: The HTTP header name.
    # :type name: str
    # 
    # :rtype: bool
    def has_header(name)
        # return name in self.__headers
    end

    # Get an HTTP header.
    #
    # :param name: The HTTP header.
    # :type name: str
    #
    # :rtype: str
    def get_header(name)
        # self.__headers.get(name)
    end

    
	# Get all HTTP header.
	#
    # :rtype: `MultiDict`
    def get_headers
        # return self.__headers
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
    def set_header(name, value)
        #self.__headers[name] = value
        #return self
    end

    # Determines if the response has content.
    #
    # Returns True if the HTTP response body has content, otherwise False.
    #
    # :rtype: bool
    def has_body
        # return self.__body != ''
    end

    # Gets the response body.
    #
    # :returns: The HTTP response body.
    # :rtype: str
    def get_body
        # return self.__body
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
    def set_body(content=nil)
        #self.__body = content or ''
        #return self

     nil

end