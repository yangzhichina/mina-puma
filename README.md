# Mina::Puma

Puma tasks for Mina deployment.

## Installation

Add this line to your application's Gemfile:

    gem 'mina-puma', require: false

## Usage

    # config/deploy.rb
    ...
    require 'mina/puma'

    # Add pids and sockets to shared paths
    set :shared_paths, %w(log tmp/sockets config/database.yml)

    ...
    task :setup do
      ...
      queue! %[mkdir -p "{deploy_to}/shared/tmp/sockets/"]
    end

    task :deploy do
      deploy do
        invoke :'git:clone'
        ...

        to :launch do
         ...
         invoke :'puma:restart'
        end
      end
    end

Available commands:

    mina puma:start
    mina puma:stop
    mina puma:restart

Default settings:

    set :puma_socket, -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.sock" }
    set :puma_ctl,  -> { "#{deploy_to}/#{shared_path}/tmp/sockets/pumactl.sock" }
    set :puma_state,  -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.state" }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
