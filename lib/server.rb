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

  # Verb
  verb = request_lines[0].split[0].downcase

  # Path
  path = request_lines[0].split(" ")[1]
  # binding.pry
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

  # Output based on verb
  output = "<html>#{message} #{verb}</html>" if path == "/"
  output = "<html>#{message}</html>" if path.split("/").count >= 2


  # Generate the Response
  puts "Sending response."
  # output = "<html>#{message} #{verb}</html>"
  response = status + "\r\n" + "\r\n" + output

  # Send the Response
  connection.puts response

  # close the connection
  connection.close
end
