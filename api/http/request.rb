
# HTTP request class.
class HttpRequest
	def initialize(method, url)
		@method = method
		@url = url
=begin
		@protocol_version = kwargs.get('protocol_version') or '1.1'
        @query = kwargs.get('query') or MultiDict()
        @headers = kwargs.get('headers') or MultiDict()
        @post_data = kwargs.get('post_data') or MultiDict()
        @body = kwargs.get('body') or ''
        @files = kwargs.get('files') or MultiDict()
=end
	end

	# Determine if the request used the given HTTP method.
    # 
    # Returns True if the HTTP method of the request is the same
    # as the specified method, otherwise False.
    # 
    # :param method: The HTTP method.
    # :type method: str
    # 
    # :rtype: bool
	def is_method
	end


	# Gets the HTTP method.
	# 
    # Returns the HTTP method used for the request.
    # 
    # :returns: The HTTP method.
    # :rtype: str
	def get_method
		return @method
	end

	# Get request URL.
	# 
    # :rtype: str
	def get_url
		return @url
	end

	# Get request URL scheme.
	# 
    # :rtype: str
	def get_url_scheme
	end


	# Get request URL host.
	# 
    # When a port is given in the URL it will be added to host.
    # 
    # :rtype: str
	def get_url_host
	end

	# Get request URL path.
	#
	# rtype: str
    def get_url_path
        # return self.__parsed_url.path.rstrip('/')
    end


	# Determines if the param is defined.
	#
    # Returns True if the param is defined in the HTTP query string,
    # otherwise False.
	#
    # :param name: The HTTP param.
    # :type name: str
	#
    # :rtype: bool
    def has_query_param(name)
        # return name in self.__query
    end


	# Gets a param from the HTTP query string.
	# 
    # Returns the param from the HTTP query string with the given
    # name, or and empty string if not defined.
    # 
    # :param name: The param from the HTTP query string.
    # :type name: str
    # :param default: The optional default value.
    # :type name: str
    #
    # :returns: The HTTP param value.
    # :rtype: str
    def get_query_param(name, default="")
        # return self.__query.get(name, (default, ))[0]
    end


	# Gets a param from the HTTP query string.
	#
    # Parameter is returned as a list of values.
    #
    # :param name: The param from the HTTP query string.
    # :type name: str
    # :param default: The optional default value.
    # :type default: list
    # 
    # :returns: The HTTP param values as a list.
    # :rtype: list
    def get_query_param_array(self, name, default=nil)
        #return self.__query.get(name, default or [])
    end

	# Get all HTTP query params.
	# 
    # :returns: The HTTP params.
    # :rtype: dict
    def get_query_params
        #return {key: value[0] for key, value in self.__query.items()}
    end


	# Get all HTTP query params.
	# 
    # Each parameter value is returned as a list.
    #
    # :returns: The HTTP params.
    # :rtype: `MultiDict`
    def get_query_params_array
        # return self.__query
    end

	# Determines if the param is defined.
	#
    # Returns True if the param is defined in the HTTP post data,
    # otherwise False.
    #
    # :param name: The HTTP param.
    # :type name: str
    #
    # :rtype: bool
    def has_post_param(name)
        #return name in self.__post_data
    end

	# Gets a param from the HTTP post data.
	#
    # Returns the param from the HTTP post data with the given
    # name, or and empty string if not defined.
    # 
    # :param name: The param from the HTTP post data.
    # :type name: str
    #
    # :param default: The optional default value.
    # :type name: str
    # 
    # :returns: The HTTP param.
    # :rtype: str
    def get_post_param(name, default="")
        # return self.__post_data.get(name, (default, ))[0]
    end


	# Gets a param from the HTTP post data.
	#
    # Parameter is returned as a list of values.
    #
    # :param name: The param from the HTTP post data.
    # :type name: str
    # :param default: The optional default value.
    # :type default: list
    #
    # :returns: The HTTP param values as a list.
    # :rtype: list
    def get_post_param_array(self, name, default=nil)
        #return self.__post_data.get(name, default or [])
    end

	# Get all HTTP post params.
	#
    # :returns: The HTTP post params.
    # :rtype: dict
    def get_post_params
        # return {key: value[0] for key, value in self.__post_data.items()}
    end

	# Get all HTTP post params.
	#
    # Each parameter value is returned as a list.
    #
    # :returns: The HTTP post params.
    # :rtype: `MultiDict`
    def get_post_params_array
        # return self.__post_data
    end


	# Determine if the request used the given HTTP version.
	#
    # Returns True if the HTTP version of the request is the same
    # as the specified protocol version, otherwise False.
	#
    # :param version: The HTTP version.
    # :type version: str
	#
    # :rtype: bool
    def is_protocol_version(version)
        # return self.__protocol_version == version
    end

	# Gets the HTTP version.
	#
    # Returns the HTTP version used for the request.
    # 
    # :returns: The HTTP version.
    # :rtype: str
    def get_protocol_version
        # return self.__protocol_version
    end

    
	# Determines if the HTTP header is defined.
	# 
    # Returns True if the HTTP header is defined, otherwise False.
    # 
    # :param name: The HTTP header.
    # :type name: str
    # 
    # :rtype: bool
    def has_header(name)
        # return name in self.__headers
    end

    
    # Get an HTTP header.
    #
    # Returns the HTTP header with the given name, or and empty
    # string if not defined.
	#
    # A comma separated list of values ir returned when header
    # has multiple values.
	#
    # :param name: The HTTP header.
    # :type name: str
	#
    # :returns: The HTTP header value.
    # :rtype: str
    def get_header(name, default="")

=begin
    	if not self.has_header(name):
        	return default

    	return ', '.join(self.__headers[name])
=end
    end

    
    # Get all HTTP headers.
    #
    # :returns: The HTTP headers.
    # :rtype: `MultiDict`
    def get_headers
        # return self.__headers
    end

    # Determines if the HTTP request body has content.
    # 
    # Returns True if the HTTP request body has content, otherwise False.
    #
    # :rtype: bool
    def has_body
        # return self.__body != ''
    end

	# Gets the HTTP request body.
	#
    # Returns the body of the HTTP request, or and empty string if
    # no content.
	#
    # :returns: The HTTP request body.
    # :rtype: str
    def get_body
        # return self.__body
    end

    # Check if a file was uploaded in current request.
    # 
    # :param name: File name.
    # :type name: str
    #
    # :rtype: bool
    def has_file(name)
        #return name in self.__files
    end

    
	# Get an uploaded file.
	# 
    # Returns the file uploaded with the HTTP request, or None.
    #
    # :param name: Name of the file.
    #:type name: str

    # :returns: The uploaded file.
    # :rtype: `File`
    def get_file(name)
=begin    	
        if name in self.__files:
            # Get only the first file
            return self.__files.getone(name)
        else:
            return File(name, path='')
=end
	end

	# Get uploaded files.
	#
    # Returns the files uploaded with the HTTP request.
	#
    # :returns: A list of `File` objects.
    # :rtype: iter
    def get_files
=begin
        # Fields might have more than one file uploaded for the same name,
        # there for it can happen that file names are duplicated.
        return chain.from_iterable(self.__files.values())
=end
    end

end