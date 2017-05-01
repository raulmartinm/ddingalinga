require_relative '../../../katana/api/http/request'
require_relative '../../../katana/api/file'
require 'test/unit'


class TestHttpRequest < Test::Unit::TestCase

	def setup
    	@url = 'http://foo.com/bar/index/'
  	end

	def teardown
    	## Nothing really
  	end

	def test_api_http_request
	    method = 'GET'	    
	    request = HttpRequest.new(method, @url)

	    assert request.is_method('DELETE') == false
	    assert request.is_method(method)
	    assert request.get_method == method

	    assert request.get_url == @url
	    assert request.get_url_scheme == 'http'
	    assert request.get_url_host == 'foo.com'
	    assert request.get_url_path == '/bar/index'  # Final "/" is removed

	    assert request.get_protocol_version == '1.1'
	    assert request.is_protocol_version('1.1')
	    assert request.is_protocol_version('2.0') == false

	    # Create a new request with a protocol version
	    request = HttpRequest.new(method, @url, '2.0')
	    assert request.get_protocol_version == '2.0'
	    assert request.is_protocol_version('2.0')
	    assert request.is_protocol_version('1.1') == false
	    request.set_protocol_version('1.1')
	    assert request.is_protocol_version('1.1')
	end

	def test_api_http_request_query
	    method = 'GET'
	    request = HttpRequest.new(method, @url)

	    # By default there are no query params
	    assert request.has_query_param('a') == false
	    assert request.get_query_param('a') == ""
	    assert request.get_query_param('a', 'B') == 'B'
	    assert request.get_query_param_array('a') == []
	    assert request.get_query_param_array('a', ['B']) == ['B']
	    assert request.get_query_params == {}
	    assert request.get_query_params_array == {}

	    # Create a request with query params
	    expected = 1
	    query = {'a' => [expected], 'b' => [2]}
	    request = HttpRequest.new(method, @url)
	    request.set_query(query)
	    assert request.has_query_param('a')
	    assert request.get_query_param('a') == expected
	    assert request.get_query_param('a', 'B') == expected
	    assert request.get_query_param_array('a') == [expected]
	    assert request.get_query_param_array('a', ['B']) == [expected]
	    assert request.get_query_params == {'a'=> expected, 'b'=> 2}
	    assert request.get_query_params_array == query
	end

	def test_api_http_request_post
	    method = 'POST'
	    request = HttpRequest.new(method, @url)

	    # By default there are no query params
	    assert request.has_post_param('a') == false
	    assert request.get_post_param('a') == ''
	    assert request.get_post_param('a', 'B') == 'B'
	    assert request.get_post_param_array('a') == []
	    assert request.get_post_param_array('a', ['B']) == ['B']
	    assert request.get_post_params == {}
	    assert request.get_post_params_array == {}

	    # Create a request with query params
	    expected = 1
	    post = {'a'=> [expected], 'b'=> [2]}
	    request = HttpRequest.new(method, @url)
	    request.set_post_data(post)
	    assert request.has_post_param('a')
	    assert request.get_post_param('a') == expected
	    assert request.get_post_param('a', 'B') == expected
	    assert request.get_post_param_array('a') == [expected]
	    assert request.get_post_param_array('a', ['B']) == [expected]
	    assert request.get_post_params == {'a'=> expected, 'b'=> 2}
	    assert request.get_post_params_array == post
	end

	def test_api_http_request_headers
	    method = 'GET'
	    request = HttpRequest.new(method, @url)

	    # By default there are no headers
	    assert request.has_header('X-Type') == false
	    assert request.get_header('X-Type') == ''
	    assert request.get_headers == {}

	    # Create a request with headers
	    expected = 'RESULT'
	    expected2 = 'RESULT-2'
	    headers = {'X-Type' => [expected, expected2]}
	    request = HttpRequest.new(method, @url)
	    request.set_headers(headers)
	    assert request.has_header('X-Type')
	    assert request.get_header('X-Missing') == ''
	    assert request.get_header('X-Missing', 'DEFAULT') == 'DEFAULT'
	    assert request.get_header('X-Type') == expected  # Gets first item
	    assert request.get_headers == {'X-Type' => [expected, expected2]}
	end

	def test_api_http_request_body
	    method = 'POST'
	    request = HttpRequest.new(method, @url)

	    # By default body is empty
	    assert request.has_body == false
	    assert request.get_body == ''

	    # Create a request with a body
	    expected = 'CONTENT'
	    request = HttpRequest.new(method, @url)
	    request.set_body(expected)
	    assert request.has_body
	    assert request.get_body == expected
	end

=begin
	def test_api_http_request_files
	    method = 'POST'
	    request = HttpRequest.new(method, @url)

	    # By default there are no files
	    assert request.has_file('test') == false
	    assert request.get_files == []

	    # When file does not exist return an empty file object
	    file = request.get_file('test')
	    assert isinstance(file, File)
	    assert file.get_name == 'test'
	    assert file.get_path == ''

	    # Create a request with a file
	    file = File.new('test', '/files', 'application/json', 'test.json', '100')
	    files = {'test' => [file]}
	    request = HttpRequest(method, @url)
	    request.set_files(files)
	    assert request.has_file('test')
	    assert request.get_file('test') == file
	    assert list(request.get_files) == [file]
	end
=end

end