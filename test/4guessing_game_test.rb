require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require 'pry'

class GuessingGameTest < Minitest::Test
  def test_it_has_instructions
    response = Faraday.get 'http://localhost:9292/game'
    assert response.body.include? "I've generated a random number between 1 and 100. Start guessing!"
  end

  def test_it_can_guess_with_query_params
    response = Faraday.get 'http://localhost:9292/game?guess=50'
    expected = response.body.include?('too high') || response.body.include?('too low') || response.body.include?('correct!')
    assert expected
  end

  def test_it_guess_with_form_data
    # Stuck on this one? Look at the "Reading the Request Body" section of the README

    url = 'http://localhost:9292/game'
    response = Faraday.post(url, guess: 50)
    expected = response.body.include?('too high') || response.body.include?('too low') || response.body.include?('correct!')
    assert expected
  end

  def test_it_can_change_the_answer_with_a_post_request
    url = 'http://localhost:9292/game/answer'
    Faraday.post(url, answer: 50)

    url = 'http://localhost:9292/game'
    response = Faraday.post(url, guess: 50)
    assert response.body.include? "correct!"
  end

  def test_it_can_cheat
    url = 'http://localhost:9292/game/answer'
    Faraday.post(url, answer: 50)
    response = Faraday.get 'http://localhost:9292/game/answer'
    assert response.body.include? "The answer is 50"

    Faraday.post(url, answer: 49)
    response = Faraday.get 'http://localhost:9292/game/answer'
    assert response.body.include? "The answer is 49"
  end

  def test_it_can_start_a_new_game
    response = Faraday.delete 'http://localhost:9292/game'
    assert response.body.include? "A new answer has been generated"
  end
end
