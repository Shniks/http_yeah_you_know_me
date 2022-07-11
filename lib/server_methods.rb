# Library that contains TCPServer
require 'socket'
require 'pry'

class Server

  attr_reader :tcp_server

  def initialize(port = 9292)
    @tcp_server = TCPServer.new(port) # Create a new instance of TCPServer on Port 9292
  end

  def sequence
    random
    connection
    read_lines
    response
    close_connection
  end

  def random
    # Generate random number
    rand(1..100)
  end

  def connection
    # Wait for a Request
    # When a request comes in, save the connection to a variable
    puts 'Waiting for Request...'
    @tcp_server.accept
  end

  # loop do

  def read_lines
    # Read the request line by line until we have read every line
    puts "Got this Request:"
    request_lines = []
    line = self.connection.gets.chomp
    while !line.empty?
      request_lines << line
      line = self.connection.gets.chomp
    end
    # Print out the Request
    puts request_lines
    request_lines
  end

  def content_length
    # Get content length
    content_length = self.read_lines.find do |line|
      line.include?("Content-Length")
    end
    content_length
  end

  def verb
    # Verb
    self.read_lines[0].split[0].downcase
  end

  def path
    # Path
    self.read_lines[0].split(" ")[1]
  end

  def guess
    # Parse the guess
    self.path.split("=").last.to_i
  end

  def g_message
  # Guess message
    return 'too high' if self.guess > self.random
    return 'too low' if self.guess < self.random
    return 'correct!' if self.guess == self.random
  end

  def status
  # Status for various verbs
    return "http/1.1 200 ok" if self.verb == "get"
    return "http/1.1 202 ok" if self.verb == "post"
    return "http/1.1 405 ok" if self.verb == "patch"
    return "http/1.1 401 ok" if self.verb == "delete"
  end

  def message
    # Message based on path
    return "Hello from the Server side!" if self.path == "/"
    return "#{self.path[1..-1]}! creating a #{self.path[1..-2]}!" if self.path.split("/").count == 2
    return "#{self.path[1..-1]}! updating a #{self.path.split("/")[1][0..-2]}!" if self.path.split("/").count == 3 && self.verb == "patch"
    return "#{self.path[1..-1]}! destroying a #{self.path.split("/")[1][0..-2]}!" if self.path.split("/").count == 3 && self.verb == "delete"
    return "I've generated a random number between 1 and 100. Start guessing!" if self.path == "/game"
    return "#{self.g_message}" if self.path.include?("guess")
    # message = "#{g_message}" if read_content.include?("guess")
  end

  def output
    # Output based on verb
    return "<html>#{self.message} #{self.verb}</html>" if self.path == "/"
    return "<html>#{self.message}</html>" if self.path.split("/").count >= 2
  end

  def response
    # Generate the Response
    puts "Sending response."
    # output = "<html>#{message} #{verb}</html>"
    response = self.status + "\r\n" + "\r\n" + self.output
    # Send the Response
    @connection.puts response
  end

  def close_connection
    # close the connection
    @connection.close
  end

# end

end

server = Server.new
server.sequence
