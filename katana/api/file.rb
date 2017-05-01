=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end
require 'open-uri'
require 'net/http'
require_relative '../logging'


# File class for API.
#
# Represents a file received or to be sent to another Service component.
#
class File

	def initialize(name, path="", mime="", filename="", size=0, token="")

		# Validate and set file name
		if (name.nil? || name.strip == "")
            raise ArgumentError.new("Invalid file name")
        end
		@name = name
        
		
		protocol = path[0,7]
        if ["file://", "http://"].include? protocol
            @path = "file://#{path}"
            protocol = "file://"
        else
            @path = path # Validate and set file path
        end

        @filename = filename
        @size = size
        @mime = mime

        # Token is required for remote file paths        
        if protocol == 'http://' && token == ""
           raise ArgumentError.new("Token is required for remote file paths")
        end
        @token = token
        
	end

	# Get parameter name.
	#
    # :rtype: str
    #
	def get_name
        return @name
    end

    # Get path.
    #
    # :rtype: str
    #
    def get_path
        return @path
    end

    # Get mime type.
    #
    # :rtype: str.
    #
    def get_mime
        return @mime
    end

	# Get file name.
	#
    # :rtype: str.
    #
    def get_filename
        return @filename
    end

	# Get file size.
	#
    # :rtype: int.
    def get_size
        return @size
    end

	# Get file server token.
    #
    # :rtype: str.
    #
    def get_token
        return @token
    end

	# Check if file exists.
	#
	# File is considered to exist if it has non empty path
	#
    # A request is made to check existence when file
    # is located in a remote file server.
    #
    # :rtype: bool.
    #
    def exists
    	return @path != ""
    end

	# Check if file is a local file.
	#
    # :rtype: bool
    # 
	def is_local
        return @path[0,7] == "file://"
    end

	# Get file data.
	#
    # Returns the file data from the stored path.
    #
    # :returns: The file data.
    # :rtype: bytes
    #
    def read
    	# Check if file is a remote file
        if @path[0,7] == "http://"
        	Loggging.log.debug "read REMOTE file"
        	begin
				return open(@path,"X-Token" => @token).read
        	rescue Exception => exc
				Loggging.log.debug "Unable to read file: #{@path}"
        	end
        else
        	Loggging.log.debug "read LOCAL file"

        	# Check that file exists locally
        	if !File.file?(@path[7,-1]) 
        		Loggging.log.debug "File does not exist: #{@path}"
        	else
        		# Read local file contents
        		return File.read(@path[7,-1])
        	end
        end
    	return [0x00].pack('C*')
    end

	# Create a copy of current object.
	#
    # :param name: File parameter name.
    # :type name: str
	# 
    # :rtype: `File`
    def copy_with_name(name)
        return self.class.new(name, @path, @mime, @filename, @size, @token)
    end

	# Create a copy of current object.
	#
    # :param mime: Mime type for the file.
    # :type mime: str
	# 
    # :rtype: `File`

    def copy_with_mime(mime)
        return self.class.new(@name, @path, mime, @filename, @size, @token)
    end

end