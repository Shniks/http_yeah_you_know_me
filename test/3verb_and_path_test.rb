require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require 'pry'

class VerbsAndPathsTest < Minitest::Test
  def test_it_can_get_to_different_paths
    response = Faraday.get 'http://localhost:9292'
    assert response.body.include? 'Hello'

    response = Faraday.get 'http://localhost:9292/dogs'
    refute response.body.include? 'Hello'
    assert response.body.include? 'dogs!'
    #Note: it would be really nice if your page showed some images of dogs
  end

  def test_it_can_post_to_different_paths
    response = Faraday.post 'http://localhost:9292'
    assert response.body.include? 'post'

    response = Faraday.post 'http://localhost:9292/dogs'
    refute response.body.include? 'post'
    assert response.body.include? 'creating a dog!'
  end

  def test_it_can_patch_to_different_paths
    response = Faraday.patch 'http://localhost:9292'
    assert response.body.include? 'patch'

    response = Faraday.patch 'http://localhost:9292/dogs/45'
    refute response.body.include? 'patch'
    assert response.body.include? 'updating a dog!'
  end

  def test_it_can_delete_to_different_paths
    response = Faraday.delete 'http://localhost:9292'
    assert response.body.include? 'delete'

    response = Faraday.delete 'http://localhost:9292/dogs/45'
    refute response.body.include? 'delete'
    assert response.body.include? 'destroying a dog!'
  end
end
