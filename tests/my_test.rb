require 'ffi-rzmq'
require File.expand_path('../../lib/karibu', __FILE__)


addr = "tcp://127.0.0.1:8900"

class Documentation
  #
  # returns documentations for services
  #
  #
  # @return [String] formatted doc string
  # 
  def self.call
    Karibu::Doc.serve_doc
  end
end

class Message

  def self.echo
    sleep(15)
    "hello world"
  end
end

# Karibu::Doc.new do
#   desc 'permits name for someone'
#   arg 'x', type: String, desc: "name of string"
# end

class TestService < Karibu::Service
  connection_string "tcp://127.0.0.1:8900"
  # expose 'Message#echo'
  expose 'Documentation#call'
  expose 'Message#echo' do
    desc 'permits name for someone'
    arg 'x', type: String, desc: "name of string"
    arg 'c', type: Integer, desc: "number of stripes"
    returns "string containing hello word", String
  end
  response_timeout 5
end


p Documentation.call
#Message.echo(x:String) # "permits name for someone", x:String(name of string)
# class Client
#   include Celluloid::ZMQ

#   def initialize(address)
#     @socket = ReqSocket.new

#     begin
#       @socket.connect(address)
#     rescue IOError
#       @socket.close
#       raise
#     end
#   end

#   def write(message)
#     @socket.send(message)
#     nil
#   end

#   def recv
#     # # id = @socket.recv()
#     # # msg = @socket.read
#     # p "waiting on recv"
#     # loop { p @socket.read }
#     # # p id
#     # # p msg
#     p 'reading'
#     test = ''
#     @socket.read test
#     p "got response: #{test}"
    
#   end
# end



TestService.start()

sleep

