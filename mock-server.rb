require 'json'
require 'sinatra'

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
  if http_method == 'POST'
    puts "Bind POST to #{path}"
    post path do
      body
    end
  elsif http_method == 'GET'
    puts "Bind GET to #{path}"
    get path do
      body
    end
  end
end

mocks = JSON.parse(File.read(file)).map do |m| Mock.create(m) end

set :port, port.to_i

for m in mocks
  bind(m.http_method, m.status, m.body, m.path)
end

get '/hello' do
  'Hello'
end

