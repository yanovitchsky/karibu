require 'ffi-rzmq'
require File.expand_path('../../lib/karibu', __FILE__)

ctx = ::ZMQ::Context.new(1)
socket = ctx.socket(::ZMQ::REQ)
socket.setsockopt(ZMQ::IDENTITY, SecureRandom.hex(4))
socket.connect("tcp://127.0.0.1:5050")
10.times do
  socket.send_string("hello world", 0)
  buff = ""
  x = socket.recv_string(buff)
  p x
  p buff
end
socket.close
# socket.close
ctx.terminate
# puts buff
