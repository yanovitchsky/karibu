# require 'rubygems'
# require 'ffi-rzmq'
# require 'celluloid/zmq'
# require 'msgpack'
# require File.expand_path('../request', __FILE__)
require 'benchmark'
require 'net/http'
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

# class CallService < Karibu::Client
#   connection_string "tcp://127.0.0.1:8900"
# end
# puts CallService::Documentation.call
# params[:phone_id], :call_tracking_id => params[:call_tracking_id]
# Benchmark.bm do |bm|
#   bm.report do
#     arr = []
#     200.times do
#       arr << Celluloid::Future.new do
#         uri = URI("http://127.0.0.1:9000/v1/stats/callperday?call_tracking_id=5130784b8a5da5d85200002e&phone_id=513078e88a5da5d852000030&start_date=2014-02-12&end_date=2014-05-11")
#         Net::HTTP.get uri # => String
#       end
#       s = arr.map {|a| a.value}
#       # CallService::StatService.call_per_day({phone_id: '513078e88a5da5d852000030', call_tracking_id: '5130784b8a5da5d85200002e', start_date: '2014-02-12', end_date: '2014-05-11'})
#     end
#   end
# end
# Net::HTTP.get("http://127.0.0.1:9000/v1/stats/callperday?call_tracking_id=5130784b8a5da5d85200002e&phone_id=513078e88a5da5d852000030&start_date=2014-02-12&end_date=2014-05-11") # => String

# Benchmark.bm do |bm|
#   bm.report do
#     arr = []
#     200.times do
#       arr << Celluloid::Future.new do
#         CallService::StatService.call_per_day({phone_id: '513078e88a5da5d852000030', call_tracking_id: '5130784b8a5da5d85200002e', start_date: '2014-02-12', end_date: '2014-05-11'})
#       end
#       s = arr.map{|a| a.value}
#     end
#   end
# end
# MessageService.connect
# puts MessageService::Documentation.call

# p "result: ------->"
# threads = []
# 10.times do |x|
#   threads << Thread.new {p "thread #{x} ===>"; p MessageService::Message.echo}
# end
class Service < Karibu::Client
  connection_string "tcp://127.0.0.1:8900"
  timeout 60
  # endpoint "Facebook::TestController"
  endpoint "Message"
end

p Service::Message.echo
# p Service::Facebook::TestController.hello_world
# class ProspectService < Karibu::Client
#   # connection_string "tcp://192.168.10.131:6000"
#   connection_string "tcp://127.0.0.1:6000"
# end

# prospect_id = "53a1a4bf504cdbe33d000001" 
# cms_site_id = "537c7eecba946a31e3000033" 


# iter = 100
# arr = []
# iter.times do |i|
#   # arr << Thread.new do
#     ProspectService::DeliveriesResource.all(prospect_id, cms_site_id)
#   # end
#   p i
# end
# 20.times{puts " "}
# ProspectService::DeliveriesResource.all(prospect_id, cms_site_id)


# arr.each{|x| x.join}
# Thread.join()
# Celluloid::Future.new do
#   prospect_id = "53f35161ba946aedd5000001"
#   cms_site_id = "53f30b33ba946a1d7400000e"
#   ProspectService::DeliveriesResource.all(prospect_id, cms_site_id)
# end

# iterations = 100
# prospect_id = "53f35161ba946aedd5000001"
# cms_site_id = "53f30b33ba946a1d7400000e"

# res1  = {}
# res2  = {}

# Benchmark.bm do |bm|
#   # sync
#   bm.report do
#     iterations.times do |i|
#       p i
#       res1[i] = ProspectService::DeliveriesResource.all(prospect_id, cms_site_id)
#     end
#   end

  #async
  # bm.report do
  #   iterations.times do
  #     arr = []
  #     arr << Celluloid::Future.new do
  #       ProspectService::DeliveriesResource.all(prospect_id, cms_site_id)
  #     end
  #     arr.each_with_index {|x, i| res2[i] =  x.value}
  #   end
  # end
# end

# threads.each{|t| t.join }

# iter = 10_000
# # Benchmark.TESTS = 10_000

# Benchmark.bm do |results|
#   results.report do
#     arr = []
#     iter.times do |i|
#       arr << MessageService::Message.echo
#     end
#     arr.each_with_index do |x, i|
#       p "message[#{i}] ==> #{x}"
#     end
#   end
# end

# Benchmark.bm do |results|
#   results.report do
#     arr = []
#     iter.times do |i|
#       arr << Celluloid::Future.new do
#         mess = MessageService::Message.echo
#       end
#     end
#     arr.each_with_index do |x, i|
#       p "message[#{i}] ==> #{x.value}"
#     end
#   end
# end
# end
# arr = []
# iter.times do |i|
#   arr << Celluloid::Future.new do
#     mess = MessageService::Message.echo
#   end
# end

# arr.each_with_index do |x, i|
#   p "message[#{i}] ==> #{x.value}"
# end

# p Service::TestController.hello_world
# MessageService::Message.echo
# MessageService::Message.echo

# p MessageService::Message.echo
# p MessageService::Message.echo
# p MessageService::Message.echo
# p MessageService::Message.hello
# rescue Karibu::Errors::MethodNotFound => e
#   p e.message
# end
# MessageService::Message.echo
# MessageService::Message.echo
# sleep
# Thread.join()