# HTTP Yeah You Know Me

This is a challenge intended to test your understanding of HTTP.

## Instructions

Clone this repository.

Run `gem install faraday`

There is a file called `server.rb` in the `lib` directory that contains code from the [HTTP Tutorial](https://backend.turing.io/module2/lessons/http_yykm_1). Run that file with `ruby <path to file>`. This will start a server which will listen for requests. Your terminal should print out "Waiting for Request..." and then hang.

Next, open up a new terminal. You can open up a new terminal window with the `cmd + n` shortcut for terminal, or open up a new terminal tab in the same window with the `cmd + t` shortcut. Run the `1response_test.rb` file located in the `test` directory. You should have passing tests!

As you work through the test suite, you will have to repeat this process. If you make changes in the `server.rb` file, you will have to close a running server with `ctrl + c` and rerun the file to load the changes before running the tests.

## Challenge 1: Verbs

Make all the tests in the `2verbs_test.rb` pass.

These tests focus on using the verb from the request to generate different responses.

As you work through these problems, you may want to refactor your code. For example, you may want to make separate methods for breaking apart the request and for building a response. These types of refactors will be useful for later challenges.

## Challenge 2: Verbs and Path

Make all the tests in the `3verbs_and_path_test.rb` pass.

These tests will force you to use both the verb and path from the request to generate a response.

Continue to refactor your code so that you can handle many different types of requests

## Challenge 3: The Guessing Game

Make all the tests in the `4guessing_game_test.rb` pass.

In this challenge, you will build out a number guessing game. Your game will generate a random number for users to guess at. The number should be the same for all requests unless a user sends a request to reset/change the number (details below). Your game should respond to the following requests:

1. `get /game` should respond with some instructions
1. `get /game?guess=50` should respond with whether the guess was too high or too low or correct.
1. `post /game` with a body of `guess=50` should respond with whether the guess was too high or too low or correct.
1. `patch /game` with a body of `answer=50` should set the answer to 50.
1. `get /game/answer` should reveal the answer.
1. `delete /game` should generate a new answer.

You can use this html snippet to generate all the html elements a user would need to make use of all these request formats from their browser.

```html
<h2>Generate a Guess with a GET request and query params</h2>

<form action="/game">
  <label>Guess: </label>
  <input type="text" name="guess">

  <input type="submit" value="Submit">
</form>

<h2>Generate a Guess with a POST request</h2>

<form action="/game" method="post">
  <label>Guess: </label>
  <input type="text" name="guess">

  <input type="submit" value="Submit">
</form>

<h2>Change the Answer with a POST request</h2>

<form action="/game/answer", method="post">
  <label>Answer: </label>
  <input type="text" name="answer">

  <input type="submit" value="Submit">
</form>
```

#### Reading the Request Body

In HTTP requests, post data appears in the **body** of the request after the headers. A blank line indicates the end of the headers and the beginning of the body. If you look at the lines of code for reading the request included in this repo, we stop reading the request once we hit that first blank line.

In order to read more data from the client, you can use the `read` method like so:

```ruby
pry(main)> connection.read(1)
```

The argument (in this case `1`) indicates how many characters you want to read. A client will indicate exactly how many characters are in the body with a header called `Content-Length`.

## Challenge 4: Redirects

When a user guesses a correct answer, rather than responding with a 200 status, redirect them to `/congratulations` that displays a special congratulations message.

For more information, see [this](https://www.httpwatch.com/httpgallery/redirection/)

## Challenge 5: Cookies

We'll now add a feature to our guessing game where it can keep track of a user's high score. One place we can store a user's current high score is in their cookies.

For more information about using cookies in http see [this](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).

We'll abandon the test suite for this challenge and instead use the browser. The browser should handle storing the cookies.

Follow these guidelines for this challenge:

* When a user guesses a correct answer, they should see a response with how many guesses they took, for example: "correct! You took 3 guesses."
* Once a user guesses a correct answer for the first time, a cookie called `high_score` should be set
* When a user guesses the correct answer again, they should be told whether or not they beat their high score.
* When a user makes an incorrect guess, they should be told what their current high score is (if they have one)
