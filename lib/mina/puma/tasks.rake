# ## Usage example
#     require 'mina/puma'
#     ...
#     task :setup do
#       queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids/"]
#       queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets/"]
#     end
#
#     task :deploy do
#       deploy do
#         to :prepare do
#           invoke :'puma:stop'
#         end
#
#         invoke :'git:clone'
#         ...
#
#         to :launch do
#           ...
#           invoke :'puma:start'
#         end
#       end
#     end

set_default :puma_pid,    -> { "#{deploy_to}/#{shared_path}/tmp/pids/puma.pid" }
set_default :puma_socket, -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.sock" }

namespace :puma do
  desc 'Start puma'
  task start: :environment do
    queue %[cd #{deploy_to}/#{current_path} && bundle exec puma -q -d -e #{rails_env} -b unix://#{puma_socket} --pidfile #{puma_pid}]
  end

  desc 'Stop puma'
  task stop: :environment do
    queue %{
      if [[ -f #{puma_pid} ]]; then
        kill -9 `cat #{puma_pid}` && rm #{puma_pid}
      fi
      if [[ -f #{puma_socket} ]]; then
        rm #{puma_socket}
      fi
    }
  end

  desc 'Restart puma'
  task restart: :environment do
    invoke :'puma:stop'
    invoke :'puma:start'
  end
end