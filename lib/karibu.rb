require 'rubygems'
# require 'bundler/setup'
require 'celluloid'
require 'ffi-rzmq'
require 'celluloid/zmq'
require 'msgpack'
require "log4r"
require "hamster"
require 'timeout'
# require 'msgpack' unless defined? JRUBY_VERSION
# require "msgpack-jruby" if defined? JRUBY_VERSION
# require 'concurrent'
require "karibu/version"
require "karibu/doc"
require "karibu/errors"
require "karibu/error_handler"
require "Karibu/logger"
require "karibu/server_request"
require "karibu/client_request"
require "karibu/response"
require "karibu/queue"
require "karibu/dispatcher"
require "karibu/server"
require "karibu/client"
require "karibu/service"

module Karibu
  # Your code goes here...
  LOGFILE = "karibu.log"
  # trap("INT") { puts "Shutting down."; exit}
end
