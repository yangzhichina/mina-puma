# Mina::Puma

Puma tasks for Mina deployment.

## Installation

Add this line to your application's Gemfile:

    gem 'mina-puma'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mina-puma

## Usage

    # config/deploy.rb
    require 'mina/puma'

    ...
    task :setup do
      queue! %[mkdir -p "{deploy_to}/shared/tmp/pids/"]
      queue! %[mkdir -p "{deploy_to}/shared/tmp/sockets/"]
    end

    task :deploy do
      deploy do
        to :prepare do
         invoke :'puma:stop'
        end

        invoke :'git:clone'
        ...

        to :launch do
         ...
         invoke :'puma:start'
        end
      end
    end

Default settings:

    set :puma_pid,    "#{deploy_to}/#{shared_path}/tmp/pids/puma.pid"
    set :puma_socket, "#{deploy_to}/#{shared_path}/tmp/sockets/puma.sock"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
