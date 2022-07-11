# Library that contains TCPServer
require 'socket'
require 'pry'

class TCPServer

  # Create a new instance of TCPServer on Port 9292
  server = TCPServer.new(9292)

  # Generate random number
  random = rand(1..100)

  loop do
    # Wait for a Request
    # When a request comes in, save the connection to a variable
    puts 'Waiting for Request...'
    connection = server.accept

    # Read the request line by line until we have read every line
    puts "Got this Request:"
    request_lines = []
    line = connection.gets.chomp
    while !line.empty?
      request_lines << line
      line = connection.gets.chomp
    end

    # Print out the Request
    puts request_lines

    # Get content length
    content_length = request_lines.find do |line|
      line.include?("Content-Length")
    end

    # Path
    path = request_lines[0].split(" ")[1]

    # Get the guess from the body using content_length
    if !content_length.nil? && !path.include?("answer")
      guess_length = content_length.split(" ")[1].to_i
      read_content = connection.read(guess_length)
      form_guess = read_content.split("=")[1].to_i
    end

    # Verb
    verb = request_lines[0].split[0].downcase

    # Parse the guess
    guess = path.split("=").last.to_i if content_length.nil?
    guess = form_guess if !content_length.nil?

    # Guess message
    g_message = 'too high' if guess > random
    g_message = 'too low' if guess < random
    g_message = 'correct!' if guess == random

    # Status for various verbs
    status = "http/1.1 200 ok" if verb == "get"
    status = "http/1.1 202 ok" if verb == "post"
    status = "http/1.1 405 ok" if verb == "patch"
    status = "http/1.1 401 ok" if verb == "delete"
    # Message based on path
    message = "Hello from the Server side!" if path == "/"
    message = "#{path[1..-1]}! creating a #{path[1..-2]}!" if path.split("/").count == 2
    message = "#{path[1..-1]}! updating a #{path.split("/")[1][0..-2]}!" if path.split("/").count == 3 && verb == "patch"
    message = "#{path[1..-1]}! destroying a #{path.split("/")[1][0..-2]}!" if path.split("/").count == 3 && verb == "delete"
    message = "I've generated a random number between 1 and 100. Start guessing!" if path == "/game"
    message = "#{g_message}" if path.include?("guess")
    message = "#{g_message}" if !guess_length.nil? && guess_length > 0

    # Output based on verb
    output = "<html>#{message} #{verb}</html>" if path == "/"
    output = "<html>#{message}</html>" if path.split("/").count >= 2

    # Generate the Response
    puts "Sending response."
    response = status + "\r\n" + "\r\n" + output
    # Send the Response
    connection.puts response

    # close the connection
    connection.close
  end

end
