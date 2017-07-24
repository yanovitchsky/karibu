# Karibu

Karibu is a RPC Library in ruby, Allowing developer to write distributed object via zeromq protocol.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'karibu', git: 'git@gitlab.visibleo.fr:visibleornd/karibu.git'
```

And then execute:

    $ bundle

## Configuration
Write a file name `boot.rb` at the root of your project folder

```ruby
require 'karibu'
```

To configure karibu options:

```ruby
Karibu::Configuration.configure do |config|
  # All parameters are defaults if not mentioned
  config.resources = [Klass] # List of class to expose to the network defaults to []
  config.workers = 10 # Number of threads to handle concurrency - be careful too much threads will result to performance degradation - defaults
  config.port = 5050 # Port where the service will listen
  config.address = '0.0.0.0' # IP Address where the service will listen
  config.timeout = 30 # Timeout long request (in seconds)
  config.logger = # Info logs - default to log/environment.log
  config.error_logger = # Error logs - default to log/environment.error.log
  config.boot_file = # Specifiy wich file to use as boot- default boot.rb
  config.pid_file = # Specifiy with pidfile to store pid - default karibu.pid
  config.daemonize = false # Put process in background mode
end
```

## Usage
In your Exposed classes, All methods exposed are class methods

EX:
```ruby
class Dummy
  def self.greet
    "Hello World"
  end
end
```

## Launch server
At installation a bin is provided to launch you server.

To start:

   $ bundle exec karibu start

To stop in daemon mode:

   $ bundle exec karibu stop

To restart in daemon mode:

   $ bundle exec karibu restart

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
