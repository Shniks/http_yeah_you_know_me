# Library that contains TCPServer
require 'socket'
require 'pry'

# Create a new instance of TCPServer on Port 9292
server = TCPServer.new(9292)

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

  #verb
  verb = request_lines[0].split[0].downcase

  # Status for various verbs
  status = "http/1.1 200 ok" if verb == "get"
  status = "http/1.1 202 ok" if verb == "post"
  status = "http/1.1 405 ok" if verb == "patch"
  status = "http/1.1 401 ok" if verb == "delete"

  # Generate the Response
  puts "Sending response."
  output = "<html>Hello from the Server side! #{verb}</html>"
  response = status + "\r\n" + "\r\n" + output

  # Send the Response
  connection.puts response

  # close the connection
  connection.close
end
