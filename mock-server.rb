require 'json'
require 'sinatra'
require 'sinatra/cross_origin'

port = ARGV[0]
file = ARGV[1]

class Mock
  def self.create(json)
    _method = json['method']
    puts _method
    Mock.new(_method, json['status'], json['body'], json['path'])
  end

  attr_accessor :http_method, :status, :body, :path
    
  def initialize(http_method, status, body, path)
    @http_method = http_method
    @status = status
    @body = body
    @path = path
  end
end

def bind(http_method, status, body, path)
  method = http_method.downcase.to_s
  send(method, path) do
    cross_origin
    body.to_json
  end
end

configure do
  enable :cross_origin
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"

  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

  200
end

mocks = JSON.parse(File.read(file)).map do |m| Mock.create(m) end

set :port, port.to_i

for m in mocks
  bind(m.http_method, m.status, m.body, m.path)
end

before do
  content_type 'application/json'
end

get '/hello' do
  'Hello'
end

