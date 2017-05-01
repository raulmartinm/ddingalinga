require_relative '../../../katana/api/http/response'

require 'test/unit'


class TestHttpResponse < Test::Unit::TestCase

    def setup
        ## Nothing really
  	end

    def teardown
        ## Nothing really
    end

	def test_api_http_response_protocol
	    response = HttpResponse.new(200, 'OK')

	    # Check default protocol
	    assert response.get_protocol_version == '1.1'
	    response.set_protocol_version(nil)
	    assert response.get_protocol_version == '1.1'

	    # Set a new protocol version
	    response.set_protocol_version('2.0')
	    assert response.get_protocol_version == '2.0'

	    assert response.is_protocol_version('1.1') == false
	    assert response.is_protocol_version('2.0')

	    # Create a response with a protocol version
	    response = HttpResponse.new(200, 'OK', '2.0')
	    assert response.get_protocol_version == '2.0'
	end

	def test_api_http_response_status
	    response = HttpResponse.new(200, 'OK')
	    assert response.is_status('200 OK')
	    assert response.get_status == '200 OK'
	    assert response.get_status_code == 200
	    assert response.get_status_text == 'OK'

	    response.set_status(500, 'Internal Server Error')
	    assert response.is_status('500 Internal Server Error')
	    assert response.get_status == '500 Internal Server Error'
	    assert response.get_status_code == 500
	    assert response.get_status_text == 'Internal Server Error'
	end

	def test_api_http_response_headers
	    response = HttpResponse.new(200, 'OK')

	    # By default there are no headers
	    assert response.has_header('X-Type') == false
	    assert response.get_header('X-Type') == ''
	    assert response.get_headers == {}

	    # Set a new header
	    expected = 'RESULT'
	    assert response.set_header('X-Type', [expected]) == response
	    assert response.has_header('X-Type')
	    assert response.get_header('X-Type') == expected
	    assert response.get_headers == {'X-Type' => [expected]}

	    # Duplicate a header
	    expected2 = 'RESULT-2'
	    response.set_header('X-Type', [expected2])
	    assert response.has_header('X-Type')
	    assert response.get_header('X-Type') == expected  # Gets first item
	    assert response.get_headers == {'X-Type' => [expected, expected2]}

	    # Create a response with headers
	    response = HttpResponse.new(200, 'OK', )
	    response.set_headers({'X-Type' => [expected]})
	    assert response.has_header('X-Type')
	    assert response.get_header('X-Type') == expected
	    assert response.get_headers == {'X-Type' => [expected]}
	end


	def test_api_http_response_body
	    response = HttpResponse.new(200, 'OK')

	    # By default body is empty
	    assert response.get_body == ''
	    assert response.has_body == false

	    # Set a content for the response body
	    expected = 'CONTENT'
	    assert response.set_body(expected) == response
	    assert response.get_body == expected
	    assert response.has_body

	    # Create a response with body
	    response = HttpResponse.new(200, 'OK')
	    assert response.set_body(expected) == response
	    assert response.get_body == expected
	    assert response.has_body
	end
end