# require 'rubygems'
# require 'ffi-rzmq'
# require 'celluloid/zmq'
require 'msgpack'
# require File.expand_path('../request', __FILE__)
require 'benchmark'
require 'net/http'
# require 'concurrent'
# require 'redis'
require File.expand_path('../../lib/karibu', __FILE__)

######################### JE COMMENCE ICI
# class Service < Karibu::Client
#   # connection_string "tcp://192.168.10.166:8901"
#   connection_string "tcp://192.168.30.13:32783"
#   timeout 60
#   endpoint "XenaController"
#   # endpoint "Message"
# end
#
# p Service::XenaController.get "SapCompany", {fields:  [:id, :name, :email, :desc, :contact, :address, :web_uri]}

class Service < Karibu::Client
  connection_string "tcp://127.0.0.1:5000"
  # endpoint "UserModuleTest"
  endpoint "XenaController"
end

# t = Time.now
# arr = []
# numbers = [25,39,28,6,65,69,13,17,52,94,94,46,8,58,
#   	       82,43,60,32,83,7,27,23,89,85,18,28,2,
#            74,58,57,32,66,84,29,8,37,70,91,4,62,91,
#            18,28,71,86,43,62,18,25,36]
# # 500.times do
# #   p Service::UserModuleTest.sort numbers
# # end
# 500.times do
#   arr << Thread.new do
#     Service::UserModuleTest.sort numbers
#   end
# end
#
# arr.each{|t| t.join}
#
# p (Time.now - t)

p Service::XenaController.get("plop", "dop")
