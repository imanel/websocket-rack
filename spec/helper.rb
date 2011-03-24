require 'rubygems'
require 'rspec'
require 'pp'
require 'stringio'

require 'rack/websocket'

Rspec.configure do |c|
  c.mock_with :rspec
end

def format_request(r)
  data = {}
  data['REQUEST_METHOD'] = r[:method] if r[:method]
  data['PATH_INFO'] = r[:path] if r[:path]
  data['SERVER_PORT'] = r[:port] if r[:port] && r[:port] != 80
  r[:headers].each do |key, value|
    data['HTTP_' + key.upcase.gsub('-','_')] = value
  end
  data['rack.input'] = StringIO.new(r[:body]) if r[:body]
  # data = "#{r[:method]} #{r[:path]} HTTP/1.1\r\n"
  # header_lines = r[:headers].map { |k,v| "#{k}: #{v}" }
  # data << [header_lines, '', r[:body]].join("\r\n")
  data
end

def format_response(r)
  data = "HTTP/1.1 101 WebSocket Protocol Handshake\r\n"
  header_lines = r[:headers].map { |k,v| "#{k}: #{v}" }
  data << [header_lines, '', r[:body]].join("\r\n")
  data
end

def handler(request, secure = false)
  connection = Object.new
  secure_hash = secure ? {'rack.url_scheme' => 'https'} : {}
  Rack::WebSocket::Handlers::Thin::HandlerFactory.build(connection, format_request(request).merge(secure_hash))
end

RSpec::Matchers.define :send_handshake do |response|
  match do |actual|
    actual.handshake.lines.sort == format_response(response).lines.sort
  end
end
