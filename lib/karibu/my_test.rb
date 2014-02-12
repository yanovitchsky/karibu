require 'ffi-rzmq'
require File.expand_path('../../karibu', __FILE__)


addr = "tcp://127.0.0.1:8900"
class Message
  def self.echo
    "hello world"
  end
end

class TestService < Karibu::Service
  connection_string "tcp://127.0.0.1:8900"
  expose 'message#echo'  
end

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

