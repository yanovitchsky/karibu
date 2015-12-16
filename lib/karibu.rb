require 'rubygems'
# require 'bundler/setup'
require 'celluloid/current'
require 'ffi-rzmq'
#require 'celluloid/zmq'
require 'msgpack'
require "log4r"
require "hamster"
require 'timeout'
require 'thor'
require 'i18n'
require 'active_support/inflector'
# require 'msgpack' unless defined? JRUBY_VERSION
# require "msgpack-jruby" if defined? JRUBY_VERSION
# require 'concurrent'
require "karibu/version"
require "karibu/doc"
require "karibu/errors"
require "karibu/error_handler"
require "karibu/logger"
require 'karibu/client_config'
require "karibu/server_request"
require "karibu/client_request"
require "karibu/response"
require "karibu/queue"
require "karibu/executor"
require "karibu/dispatcher"
require "karibu/server"
require 'karibu/connection_robin'
require "karibu/client"
require "karibu/service"
require "karibu/cli"
require "karibu/helpers"

module Karibu
  # Your code goes here...
  # LOGFILE = "test1"

  KARIBU_ENV = ENV['KARIBU_ENV'] || 'development'
  LOGGER = Karibu::Logger.new()
  # trap("INT") { puts "Shutting down."; exit}
  trap("INT") {
    puts "Shutting down."
    system("kill -9 #{Process.pid}")
  }
end
