=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

class Transport

	def initialize(payload)
		@transport = payload
	end

	# Gets the request ID.
	#
	# Returns the request ID of the Transport.
	#
    # :returns: The request ID.
    # :rtype: str
    #
	def get_request_id
		return @transport.get_path("meta","id")
	end

	# Get request timestamp.
	#
	# :rtype: str
    #
	def get_request_timestamp
		return @transport.get_path("meta","datetime")
	end

	# Get transport origin.
	#
	# Origin is a tuple with origin name and version.
	#
	# :rtype: list
    #
	def get_origin
		return @transport.get_path("meta","origin")
	end


	# Get a userland property.
	#
	# :param name: Name of the property.
    # :type name: str
    # :param default: A default value to return when property is missing.
    # :type default: str
	#
	# :rtype: str
    #	
	def get_property(name, default= "")
		return @transport.get_path("meta","properties", name) { default }
	end

	# Determines if a download has been registered.
	#
	# Returns True if a download has been registered, otherwise False.
	#
	# :rtype: bool
    #
	def has_download
	end

	# Gets the download from the Transport.
	#
	# Return the download from the Transport as a File object.
	#
	# :returns: The File object.
    # :rtype: `File`
    #
	def get_download
	end


	# Get data from Transport.
	#
	# By default get all data from Transport.
	#
	# :param service: Service name.
    # :type service: str
    # :param version: Service version.
    # :type version: str
    # :param action: Service action name.
    # :type action: str

    # :returns: The Transport data.
    # :rtype: object	
	#
	def get_data(service, version, action)
		return @transport.get_path("data",service, version, action)
	end

	# Get relations from Transport.
	# 
    # Return all of the relations as an object, as they are stored in the
    # Transport. If the service is specified, it only returns the relations
    # stored by that service.

    # :param service: Service name
    # :type service: str

    # :returns: The relations from the Transport.
    # :rtype: object
	#
	def get_relations(service)
		return @transport.get_path("relations",service)
	end


	# Gets the links from the Transport.
	# 
    # Return all of the links as an object, as they are stored in the
    # Transport. If the service is specified, it only returns the links
    # stored by that service.
	# 
    # :param service: The optional service.
    # :type service: str
	# 
    # :returns: The links from the Transport.
    # :rtype: object
    # 
	def get_links(service)
		return @transport.get_path("links",service)
	end

	# Gets the calls from the Transport.
	# 
    # Return all of the internal calls to Services as an object, as
    # they are stored in the Transport. If the service is specified,
    # it only returns the calls performed by that service.
	# 
    # :param service: The optional service.
    # :type service: str
    # 
    # :returns: The calls from the Transport.
    # :rtype: object
    #
	def get_calls(service)
		return @transport.get_path("calls",service)
	end

	# Gets the transactions from the Transport.
	# 
    # Return all of the internal Service transactions as an object, as
    # they are stored in the Transport. If the service is specified,
    # it only returns the transactions registered by that service. Note
    # that at this point the registered transactions have already been
    # executed by the Gateway.
	# 
    # :param service: The optional service.
    # :type service: str
	# 
    # :returns: The transactions from the Transport.
    # :rtype: object
    #
	def get_transactions(service)
		return @transport.get_path("transactions",service)
	end

	# Gets the errors from the Transport.
	# 
    # Return all of the Service errors as an object, as they
    # are stored in the Transport. If the service is specified,
    # it only returns the errors registered by that service.
	# 
    # :param service: The optional service.
    # :type service: str
	# 
    # :returns: The errors from the Transport.
    # :rtype: object
    #
	def get_errors(service)
		return @transport.get_path("errors",service)
	end

end