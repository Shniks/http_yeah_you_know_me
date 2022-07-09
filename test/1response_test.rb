require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require 'pry'

class ResponseTest < Minitest::Test
  # Before running this test suite, start a server listening on port 9292

  def test_it_can_get_a_response
    response = Faraday.get 'http://localhost:9292'
    assert_equal 200, response.status
  end

  def test_it_can_get_multiple_responses
    Faraday.get 'http://localhost:9292'
    Faraday.get 'http://localhost:9292'
    response = Faraday.get 'http://localhost:9292'
    assert_equal 200, response.status
  end

end
