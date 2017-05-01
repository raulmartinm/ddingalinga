=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
=end

require 'deep_fetch'
require_relative 'logging'
require_relative 'utils'


# class to wrap and access payload data using paths.
#
# Global payload field names mappings are used by default.
#
class Payload

	# Payload entity name
	@name = 'void'

	# Disable field mappings in all payloads
	@@DISABLE_FIELD_MAPPINGS = false

	# Field name mappings for all payload fields
	@@FIELD_MAPPINGS = {
	    'action' => 'a',
	    'address' => 'a',
	    'arguments' => 'a',
	    'attributes' => 'a',
	    'available' => 'a',
	    'actions' => 'ac',
	    'array_format' => 'af',
	    'base_path' => 'b',
	    'body' => 'b',
	    'buffers' => 'b',
	    'busy' => 'b',
	    'cached' => 'c',
	    'call' => 'c',
	    'callback' => 'c',
	    'callee' => 'c',
	    'client' => 'c',
	    'code' => 'c',
	    'collection' => 'c',
	    'command' => 'c',
	    'commit' => 'c',
	    'component' => 'c',
	    'config' => 'c',
	    'count' => 'c',
	    'cpu' => 'c',
	    'caller' => 'C',
	    'calls' => 'C',
	    'complete' => 'C',
	    'command_reply' => 'cr',
	    'data' => 'd',
	    'datetime' => 'd',
	    'default_value' => 'd',
	    'disk' => 'd',
	    'path_delimiter' => 'd',
	    'deferred_calls' => 'dc',
	    'deprecated' => 'D',
	    'allow_empty' => 'e',
	    'entity_path' => 'e',
	    'errors' => 'e',
	    'entity' => 'E',
	    'error' => 'E',
	    'enum' => 'em',
	    'exclusive_min' => 'en',
	    'exclusive_max' => 'ex',
	    'family' => 'f',
	    'field' => 'f',
	    'filename' => 'f',
	    'files' => 'f',
	    'format' => 'f',
	    'free' => 'f',
	    'fallback' => 'F',
	    'fallbacks' => 'F',
	    'fields' => 'F',
	    'gateway' => 'g',
	    'header' => 'h',
	    'headers' => 'h',
	    'http' => 'h',
	    'http_body' => 'hb',
	    'http_input' => 'hi',
	    'http_method' => 'hm',
	    'http_security' => 'hs',
	    'id' => 'i',
	    'idle' => 'i',
	    'in' => 'i',
	    'input' => 'i',
	    'interval' => 'i',
	    'items' => 'i',
	    'primary_key' => 'k',
	    'laddr' => 'l',
	    'level' => 'l',
	    'links' => 'l',
	    'memory' => 'm',
	    'message' => 'm',
	    'meta' => 'm',
	    'method' => 'm',
	    'mime' => 'm',
	    'min' => 'mn',
	    'multiple_of' => 'mo',
	    'max' => 'mx',
	    'name' => 'n',
	    'network' => 'n',
	    'min_items' => 'ni',
	    'min_length' => 'nl',
	    'optional' => 'o',
	    'origin' => 'o',
	    'out' => 'o',
	    'param' => 'p',
	    'params' => 'p',
	    'path' => 'p',
	    'pattern' => 'p',
	    'percent' => 'p',
	    'pid' => 'p',
	    'post_data' => 'p',
	    'properties' => 'p',
	    'protocol' => 'p',
	    'query' => 'q',
	    'raddr' => 'r',
	    'reads' => 'r',
	    'request' => 'r',
	    'required' => 'r',
	    'relations' => 'r',
	    'result' => 'r',
	    'rollback' => 'r',
	    'remote_calls' => 'rc',
	    'response' => 'R',
	    'return' => 'R',
	    'schema' => 's',
	    'schemes' => 's',
	    'scope' => 's',
	    'service' => 's',
	    'shared' => 's',
	    'size' => 's',
	    'status' => 's',
	    'swap' => 's',
	    'system' => 's',
	    'terminate' => 't',
	    'token' => 't',
	    'total' => 't',
	    'transactions' => 't',
	    'type' => 't',
	    'transport' => 'T',
	    'url' => 'u',
	    'used' => 'u',
	    'user' => 'u',
	    'unique_items' => 'ui',
	    'value' => 'v',
	    'version' => 'v',
	    'validate' => 'V',
	    'iowait' => 'w',
	    'writes' => 'w',
	    'timeout' => 'x',
	    'max_items' => 'xi',
	    'max_length' => 'xl',
	}

	def initialize(payload={})
		@payload = payload		
	end

	def set_payload(paylaod)
		@payload = paylaod
	end

	def get_payload
		return @payload
	end

	def set_fieldmappings (fieldmappings)
		@@DISABLE_FIELD_MAPPINGS = fieldmappings
	end

	def get_path(*args, &block)
		raise ArgumentError.new("wrong number of arguments (0 for 1..n)") if args.empty?
		
		if (@@DISABLE_FIELD_MAPPINGS)
			return @payload.deep_fetch(*args, &block)
		else			
			argsn = Array.new
			args.each do |arg|
				argsn.push(@@FIELD_MAPPINGS[arg])
			end
			return @payload.deep_fetch(*argsn, &block)
		end
	end

	def path_exists(*args)
		return !get_path(*args){nil}.nil?
	end		


	def get_param(location, name, value = nil, &block)
		argsn = Array.new		
		if (@@DISABLE_FIELD_MAPPINGS)
			argsn.push(location)
			argsn.push(name)
			if (!value.nil?)
				argsn.push(value)
			end
		else
			argsn.push(@@FIELD_MAPPINGS[location])
			argsn.push(name)
			if (!value.nil?)
				argsn.push(@@FIELD_MAPPINGS[value])
			end
		end
		return @payload.deep_fetch(*argsn, &block)
	end

	def deep_nest(*args, value)
		raise ArgumentError.new("wrong number of arguments (0 for 1..n)") if args.empty?

		if (@@DISABLE_FIELD_MAPPINGS)
			argsn = args
		else
			argsn = Array.new
			args.each do |arg|
				argsn.push(@@FIELD_MAPPINGS[arg] || arg)
			end
		end		
		@payload.merge!((argsn + [value]).reverse.reduce { |s,e| { e => s } }) { |k,o,n| o.merge(n) }
	end

	def deep_nestdata(*args, value)
		args.unshift(@name)
		self.deep_nest(*args,value)
	end

	def set_data(data)
		self.deep_nest(@name,data)
	end

	def get_data(*args, &block)
		return self.get_path(@name, *args, &block)
	end

	def has_data
		return @payload.empty?
	end

	def get_names
		return @payload.keys
	end


	def to_s
		return @payload.to_s
	end
end

# Class definition for error payloads.
#
class ErrorPayload < Payload

	def initialize
		super
		@name = "error"
		deep_nest(@name, "message", "Unknown error")
		deep_nest(@name, "code", 0)
		deep_nest(@name, "status", "500 Internal Server Error")
	end

	def init(message=nil, code=nil, status=nil)
		if  message.nil?
			deep_nest(@name, "message", message)
		end

		if code.nil?
			deep_nest(@name, "code", code)
		end

		if status.nil?
			deep_nest(@name, "status", status)
		end

		return get_payload
	end

end

# Class definition for request/response meta payloads.
#
class MetaPayload < Payload

	def initialize
		super
		@name = "meta"
	end

    def init(version, id, protocol, gateway, client)
        deep_nest(@name,"version", version)
        deep_nest(@name,"id", id) # request_id
        deep_nest(@name,"protocol", protocol) 
        deep_nest(@name,"gateway", gateway) 
        deep_nest(@name,"client", client) 
        deep_nest(@name,"datetime", date_to_str(DateTime.now.new_offset(0))) # DateTime.now.new_offset(0) or Time.now.utc
        return get_payload
    end
end

# Class definition for HTTP request payloads.
#
class HttpRequestPayload < Payload

    def initialize
		super
		@name = "request"
	end

	def init(request, files=nil)
        deep_nest(@name,"version", request.version)
        deep_nest(@name,"method", request.method) 
        deep_nest(@name,"url", request.url) 
        deep_nest(@name,"body", request.body || "") 
        
		if !request.query.nil?
            deep_nest(@name,"query", request.query)
         end

        if !request.post_data.nil?
            deep_nest(@name,"post_data", request.post_data)
        end

        if !request.headers.nil?
            deep_nest(@name,"headers", request.headers)
        end

        if !files.nil?
            deep_nest(@name,"files", files)
        end

        return get_payload
    end
end


# Class definition for response payloads.
#
class ResponsePayload < Payload

    def initialize
		super
		@name = "response"
	end

	def init(version=nil, status=nil, body=nil, headers=nil)
        deep_nest(@name,"version", request.version)
        deep_nest(@name,"status", request.version)
        deep_nest(@name,"body", request.version)
		if !headers.nil?
            deep_nest(@name,"headers", headers)
        end
        return get_payload
    end
end

# Class definition for service call payloads.
#
class ServiceCallPayload < Payload

    def initialize
		super
		@name = "call"
	end	

	def init(service=nil, version=nil, action=nil, params=nil)
        deep_nest(@name,"service", service || "")
        deep_nest(@name,"version", version || "")
        deep_nest(@name,"action", action || "")
        deep_nest(@name,"params", params || [])
        return get_payload
	end
end

# Class definition for transport payloads.
#
class TransportPayload < Payload

	def initialize
		super
		@name = "transport"
		deep_nest(@name,"body", {})
        deep_nest(@name,"files", {})
        deep_nest(@name,"data", {})
        deep_nest(@name,"relations", {})
        deep_nest(@name,"links", {})
        deep_nest(@name,"calls", {})
        deep_nest(@name,"transactions", {})
        deep_nest(@name,"errors", {})
	end

	def init(version, request_id, origin=nil, date_time=nil, *agrs)
		deep_nest(@name,"meta","version", version)
        deep_nest(@name,"meta","id", request_id)        
        deep_nest(@name,"meta","datetime", date_time || date_to_str(DateTime.now.new_offset(0)))
		deep_nest(@name,"meta","origin", origin || [])
=begin        
        deep_nest(@name,"meta","gateway", kwargs.get('gateway'))
        if kwargs.get('properties')
            deep_nest(@name,"meta","properties", kwargs['properties'])
         end
=end
        deep_nest(@name,"meta","level", 1)
		return get_payload
	end
end

# Class definition for command payloads.
#
class CommandPayload < Payload

	def initialize
		super
		@name = "command"
		deep_nest(@name, "arguments", nil)
	end

	def init(name, scope, args=nil)		
		deep_nest(@name, "name", name)
		deep_nest(@name, "scope", scope) # TODO [to ask -> payload.set('meta/scope', scope)]
		if !args.nil?
			deep_nest(@name, "arguments", args)
		end

		return get_payload
	end
end

# Class definition for command result payloads.
#
class CommandResultPayload < Payload

	def initialize
		super
		@name = "command_reply"
	end

	def init(name, result=nil)		
		deep_nest(@name, "name", name)
		deep_nest(@name, "result", result)		
		return get_payload
	end
end