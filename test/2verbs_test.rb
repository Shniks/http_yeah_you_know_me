require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require 'pry'

class VerbsTest < Minitest::Test
  def test_it_sends_a_welcome_message
    response = Faraday.get 'http://localhost:9292'
    assert response.body.include? 'Hello'
  end

  def test_it_can_respond_to_a_post_request
    response = Faraday.post 'http://localhost:9292'
    assert_equal 202, response.status
    assert response.body.include? 'post'
  end

  def test_it_can_respond_to_a_patch_request
    response = Faraday.patch 'http://localhost:9292'
    assert_equal 405, response.status
    assert response.body.include? 'patch'
  end

  def test_it_can_respond_to_a_delete_request
    response = Faraday.delete 'http://localhost:9292'
    assert_equal 401, response.status
    assert response.body.include? 'delete'
  end
end
