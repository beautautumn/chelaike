namespace :official do
  desc "重启本地puma服务"
  task restart_puma: :environment do
    system_cmd = <<-CMD
      ~/.rvm/bin/rvm 2.3.0 do bundle exec pumactl -S /home/deploy/official-site/shared/tmp/pids/puma.state restart
    CMD

    system(system_cmd)
  end
end
