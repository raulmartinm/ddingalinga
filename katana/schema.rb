=begin
Ruby 3 SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require 'singleton'
require_relative 'errors'
require_relative 'payload'



# Global service schema registry.
#
class SchemaRegistry
    include Singleton

    def initialize()
        @mappings = Payload.new()
    end

    # Check if a value is the empty value.
    #
    # :rtype: bool
    #
    def is_empty(value)
        return @mappings.path_exists(value)
    end


    # Check if registry contains mappings.
    #
    # :rtype: bool
    #
    def has_mappings()
        return @mappings.has_data()
    end

    
    # Update schema registry with mappings info.
    #
    # :param mappings: Mappings payload.
    # :type mappings: dict
    #
    def update_registry(mappings)
        @mappings = Payload.new(mappings || {})
    end

    # Check if a path is available.
    #
    # For arguments see `Payload.path_exists()`.
    #
    # :param path: Path to a value.
    # :type path: str
    #
    # :rtype: bool
    #
    def path_exists(path)
        return @mappings.path_exists(path)
    end

    # Get value by key path.
    #
    # For arguments see `Payload.get()`.
    #
    # :param path: Path to a value.
    # :type path: str
    #
    # :returns: The value for the given path.
    # :rtype: object
    #
    def get(*args, &block)
        return @mappings.get_path(*args, &block)
    end

    # Get the list of service names in schema.
    #
    # :rtype: list
    #
    def get_service_names()
        return @mappings.get_names()
    end
end


# Get global schema registry.
#
# :rtype: SchemaRegistry
#
def get_schema_registry()

    if !SchemaRegistry.instance
        raise KatanaError.new("Global schema registry is not initialized")
    end

    return SchemaRegistry.instance
end