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
class Service < Karibu::Client
  connection_string "tcp://127.0.0.1:9292"
  timeout 60
  endpoint "XenaController"
  # endpoint "Message"
end

Service::XenaController.get "SapCompany", {fields: [:id]}
