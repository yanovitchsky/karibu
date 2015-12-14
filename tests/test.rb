# require 'rubygems'
# require 'ffi-rzmq'
# require 'celluloid/zmq'
# require 'msgpack'
# require File.expand_path('../request', __FILE__)
require 'benchmark'
require 'net/http'
require 'concurrent'
# require 'redis'
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


# addr = "tcp://127.0.0.1:8900"


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

######################### JE COMMENCE ICI
# class Service < Karibu::Client
#   connection_string "tcp://127.0.0.1:8900"
#   timeout 60
#   endpoint "Facebook::TestController"
#   # endpoint "Message"
# end

# # p Service::Message.echo
# arr = []
# t = Time.now
# 400.times do
#   arr << Thread.new { p Service::Facebook::TestController.hello_world }
# end
# arr.each{|x| x.join}
# p Time.now - t

# Benchmark.TESTS = 10_000
# Benchmark.bmbm do |results|
#   results.report
# end
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




# require 'redis'

# ids = ["50e9eaf7aa51fc81fe000001", "50e9eaf7aa51fc81fe000002", "50e9eaf8aa51fc81fe000003", "50e9eaf8aa51fc81fe000004", "50e9eaf8aa51fc81fe000005", "50e9eaf9aa51fc81fe000006", "50e9eaf9aa51fc81fe000007", "50e9eaf9aa51fc81fe000008", "50e9eaf9aa51fc81fe000009", "50e9eafaaa51fc81fe00000a", "50e9eafaaa51fc81fe00000b", "50e9eafaaa51fc81fe00000c", "50e9eafbaa51fc81fe00000d", "50e9eb01aa51fc81fe000022", "50e9eafbaa51fc81fe00000e", "50e9eafbaa51fc81fe00000f", "50e9eafbaa51fc81fe000010", "50e9eafcaa51fc81fe000011", "50e9eafcaa51fc81fe000012", "50e9eafcaa51fc81fe000013", "50e9eafdaa51fc81fe000014", "50e9eafdaa51fc81fe000015", "50e9eafdaa51fc81fe000016", "50e9eafdaa51fc81fe000017", "50e9eafeaa51fc81fe000018", "50e9eafeaa51fc81fe000019", "50e9eafeaa51fc81fe00001a", "50e9eaffaa51fc81fe00001b", "50e9eaffaa51fc81fe00001c", "50e9eaffaa51fc81fe00001d", "50e9eb00aa51fc81fe00001e", "50e9eb00aa51fc81fe00001f", "50e9eb00aa51fc81fe000020", "50e9eb00aa51fc81fe000021", "50e9eb01aa51fc81fe000023", "50e9eb01aa51fc81fe000024", "50e9eb02aa51fc81fe000025", "50e9eb02aa51fc81fe000026", "50e9eb02aa51fc81fe000027", "50e9eb02aa51fc81fe000028", "50e9eb03aa51fc81fe000029", "50e9eb03aa51fc81fe00002a", "50e9eb03aa51fc81fe00002b", "50e9eb03aa51fc81fe00002c", "50e9eb04aa51fc81fe00002d", "50e9eb04aa51fc81fe00002e", "50e9eb04aa51fc81fe00002f", "50e9eb05aa51fc81fe000030", "50ee9e6073f4100f2b000004", "50eea37d73f410a7a5000146"]


# redis = Redis.new

# ids.each do |id|
#   redis.rpush("Jarvis:contracts", id)
# end
class Service < Karibu::Client
  connection_string "tcp://127.0.0.1:5050"
  timeout 60
  endpoint "Jarvis"
  symbolize_keys false
end
# class CorleoneApiService < Karibu::Client
#   connection_string "tcp://leeloo.api.sx:8900"
#   timeout 60
#   endpoint "CorleoneService::ActivitiesController"
#   # endpoint "Message"
# end
# p Service::Jarvis.find :pack_id, :calltracking_id, "50850beb8a5da54521000038" #=> {:pack_id => "" | [], calltracking_id: "50850beb8a5da54521000038"}
t = Time.now
res = Service::Jarvis.find :contract_id, {phoneline_id: ["508512e78a5da54521000043","50815f1c8a5da5452100002b","50b492718a5da5b453000013","50811a728a5da54521000019"]} #=> {:pack_id => "" | [], calltracking_id: "50850beb8a5da54521000038"}
p res
res2 = Service::Jarvis.find :phoneline_id, {pack_id: "508a51548a5da50bd2000082"}
p res2
p Time.now - t
# p Service::Jarvis.add_adwords_accounts({id: "8480380987", name: "20TH DISTRICT - C501092084115822-2073"})
# arr = []
# 22.times do
#   arr << Celluloid::Future.new {Service::Jarvis.find :pack_id, :calltracking_id, "51add8278a5da5d8520001bb"}
# end

# arr.each {|x| p x.value}
# p CorleoneApiService::CorleoneService::ActivitiesController.get_all({:filters=>{:status=>0}, :orders=>{:status=>"asc", :name=>"asc"}})
#
# class Service < Karibu::Client
#   # connection_string ["tcp://127.0.0.1:8900", "tcp://127.0.0.1:8901", "tcp://127.0.0.1:8902"]
#   connection_string "tcp://127.0.0.1:8900"
#   timeout 60
#   endpoint "Message"
# #   # endpoint "Message"
# end
# p Service::Message.echo(23)
#
# # my_pool = Concurrent::FixedThreadPool.new(10)
# arr = []
# t = Time.now
# 150.times do |n|
#   # my_pool.post do
#   arr << Thread.new do
#     p  "My number is #{n} and #{Service::Message.echo(n)}"
#   end
# end
#
# # my_pool.wait_for_termination
# arr.each{|t| t.join}
# p "finished in #{Time.now - t}"
# p Service::Message.echo
