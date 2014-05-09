# require 'rubygems'
# require 'ffi-rzmq'
# require 'celluloid/zmq'
# require 'msgpack'
# require File.expand_path('../request', __FILE__)
require File.expand_path('../../lib/karibu/', __FILE__)

# Celluloid::ZMQ.init


# class Call
#   def self.stats(nbr)
#     p "i got #{nbr}"
#   end
# end
# class Server
#   include Celluloid::ZMQ

#   def initialize(address)
#     @socket = RouterSocket.new
#     @full_msg = []
#     begin
#       @socket.bind(address)
#     rescue IOError
#       @socket.close
#       raise
#     end
#   end

#   def run
#     loop { async.handle_message @socket.read }
#   end

#   def handle_message(message)
#     puts "got message: #{message}"
#     # format_message message
#   end

#   def format_message(msg)
#     @full_msg << msg
#     if @full_msg.size == 3
#       exec_request(@full_msg[2])
#       @full_msg = []
#     end
    
#   end

#   def exec_request(msg)
#     p msg
#     request = Karibu::Request.new(msg)
#     klass = Kernel.const_get(request.resource)
#     meth  = request.method_called
#     params = request.params
#     klass.send(meth, *params)
#   end
# end

# class Client
#   include Celluloid::ZMQ

#   def initialize(address)
#     @socket = DealerSocket.new

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
# end

# addr = 'tcp://127.0.0.1:3435'

# server = Server.new(addr)
# client = Client.new(addr)
# client2 = Client.new(addr)

# server.async.run
# msg = MessagePack.pack([0, 1, 'Call', "stats", [23]])
# client.async.write(msg)
# client2.async.write(msg)

# sleep

# class MessageService < Karibu::Service
#   expose "call#stats"
#   expose "call#daily_stats"
#   connection_string 'tcp://127.0.0.1:3435'

#   def on_connection
    
#   end

#   def on_deconnexion
    
#   end
# end
# MessageService.start()


addr = "tcp://127.0.0.1:8900"


# class NClient
#   # include Celluloid
#   def initialize(addr)
#     ctx = ::ZMQ::Context.new(1)
#     @socket = ctx.socket(::ZMQ::REQ)
#     begin
#       @socket.connect(addr)
#     rescue IOError
#       @socket.close
#     end
#   end

#   def write(msg)
#     @socket.send_string(msg)
#   end

#   def recv
#     s = ""
#     @socket.recv_string s
#     MessagePack.unpack s
#   end
# end

# client = NClient.new(addr)
# msg = MessagePack.pack([0, 1, 'Message', 'toto', []])

# client.write(msg)
# p client.recv()

class MessageService < Karibu::Client
  connection_string "tcp://127.0.0.1:8900"
end

# MessageService.connect
puts MessageService::Documentation.call

# p "result: ------->"
# threads = []
# 10.times do |x|
#   threads << Thread.new {p "thread #{x} ===>"; p MessageService::Message.echo}
# end

# threads.each{|t| t.join }
# p MessageService::Message.test
p MessageService::Message.echo
# p MessageService::Message.echo
# p MessageService::Message.hello
# rescue Karibu::Errors::MethodNotFound => e
#   p e.message
# end
# MessageService::Message.echo
# MessageService::Message.echo
# sleep
# Thread.join()