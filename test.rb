require 'ffi-rzmq'
require 'concurrent'
require File.expand_path('../lib/karibu', __FILE__)

ctx = ZMQ::Context.new
# hash = Concurrent::Map.new
# router = ctx.socket(ZMQ::ROUTER)
# router.bind("inproc://mytest.test")
# p router
# thr = Thread.new do
#   loop {
#     p "waiting"
#     id = ''
#     empty = ''
#     msg = ''
#     router.recv_string id
#     p id
#     router.recv_string empty
#     router.recv_string msg
#
#     hash[id] = msg
#     p hash[id]
#     # p "id = #{id}"
#     # p "msg = #{msg}"
#     # p "sending "
#     # router.send_string id, ZMQ::SNDMORE
#     # router.send_string '', ZMQ::SNDMORE
#     # router.send_string msg
#
#   }
# end


# dealer.identity = 'abcd'



# sleep(2)

1.times.each do |t|
  Thread.new do
    dealer = ctx.socket(ZMQ::REQ)
    dealer.connect("tcp://127.0.0.1:5050")
    # id = ARGV[0] || 0
    sleep rand(10)
    msg = ""
    p "sending message #{t}"
    request = MessagePack.pack([0, '1', 'Dummy', 'greet', []])
    p request
    dealer.send_string(request, 0)
    dealer.recv_string msg
    response = MessagePack.unpack(msg)
    p response
    # dealer.send_string("[#{id}] Request #{t}", 0)
    # dealer.recv_string msg
    # p "#{t} Response is #{msg}"
  end.abort_on_exception = true
end

sleep(20)

# hash.each_key do |k|
#   p "#{k} => #{hash[k]}"
# end
# ctx.destroy
# thr.exit


# ctx = ZMQ::Context.new
# rep = ctx.socket(ZMQ::ROUTER)
# sock = rep.bind("inproc://send.receive")
# req = ctx.socket(ZMQ::DEALER)
# req.connect("inproc://send.receive")
# req.send("ping") # true
# rep.recv # "ping"
#
# ctx.destroy
