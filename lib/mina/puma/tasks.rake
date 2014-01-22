set_default :puma_socket, -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.sock" }
set_default :puma_ctl,  -> { "#{deploy_to}/#{shared_path}/tmp/sockets/pumactl.sock" }
set_default :puma_state,  -> { "#{deploy_to}/#{shared_path}/tmp/sockets/puma.state" }


namespace :puma do
  desc 'Start puma'
  task start: :environment do
    queue %[cd #{deploy_to}/#{current_path} && bundle exec puma #{start_options}]
  end

  desc 'Stop puma'
  task stop: :environment do
    queue %[cd #{deploy_to}/#{current_path} && bundle exec pumactl -S #{puma_state} stop]
  end

  desc 'Restart puma'
  task restart: :environment do
    queue %[
      if [ -f #{puma_ctl} ]; then
        cd #{deploy_to}/#{current_path}  && bundle exec pumactl -S #{puma_state} restart
      else
        cd #{deploy_to}/#{current_path} && bundle exec puma #{start_options}
      fi
    ]
  end
end

def start_options
  if File.exists?("./config/puma.rb")
    "-q -d -e #{rails_env} -C ./config/puma.rb"
  else
    "-q -d -e #{rails_env} -b 'unix://#{puma_socket}' -S #{puma_state} --control 'unix://#{puma_ctl}'"
  end
end