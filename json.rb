require 'json'

# https://github.com/flori/json
# Convert a JSON string to Ruby.
#
# :rtype: a Ruby type
def deserialize(json_string)
    return JSON.parse(json_string)
end

# Serialize a Ruby object to JSON string.
#
# :returns: Bytes, or string when encoding is nil.
def serialize(data, encoding="utf-8", prettify=false)
    if !prettify
    	# value = data.to_json
        value = JSON.generate(data)
    else
        value = JSON.pretty_generate(data)
    end

    return  if encoding!=nil ? value.force_encoding(encoding) : value
end