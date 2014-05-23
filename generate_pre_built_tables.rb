require 'net/http'
require 'webrick'

PORT = 9999

thread = Thread.new {
  # `ruby -run -e httpd ./_site -p 9999`
  WEBrick::HTTPServer.new(:Port => PORT, :DocumentRoot => '../frontend/_site').start
}

sleep 1

page = Net::HTTP.get(URI "http://localhost:#{PORT}")

puts page

thread.join

# require 'webrick'

# `jekyll build`

# root = File.expand_path './_site'
# server = WEBrick::HTTPServer.new :Port => 4000, :DocumentRoot => root

# trap 'INT' do server.shutdown end

# server.start