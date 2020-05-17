# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "prime-server"
# set :repo_url, "git@git.che3bao.com:autobots/prime-server.git"
set :repo_url, "git@git.chelaike.com:autobots/prime-server.git"

# Default branch is :master
ask :branch, "master"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> do
  if fetch(:stage).to_s == "staging"
    "/home/deploy/projects/#{fetch(:application)}"
    # "/home/deploy/projects/#{fetch(:application)}/peter_zhao"
  elsif fetch(:stage).to_s == "prerelease"
    "/home/deploy/prerelease/#{fetch(:application)}"
  else
    "/home/deploy/#{fetch(:application)}"
  end
end

set :rails_env, ->{ fetch(:stage) }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push("config/database.yml",
                                                 "config/secrets.yml",
                                                 "config/application.yml",
                                                 "config/chejianding/rsa_private_key.pem",
                                                 "config/chejianding/rsa_public_key.pem",
                                                 "config/pingpp/rsa_public_key.pem",
                                                 "config/pingpp/rsa_private_key.pem",
                                                 "config/pingpp/pingpp_rsa_public_key.pem")

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push(
  "log",
  "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/files",
  "vendor/bundle",
  "public/system"
)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :rvm_ruby_version, "2.2.4"

# set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
# set :unicorn_pid, -> { "#{current_path}/tmp/pids/unicorn.pid" }

# DB SYNC
set :db_local_clean, true
set :disallow_pushing, true

# PUMA
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
# set :puma_bind, "tcp://0.0.0.0:8686"
set :puma_bind, "tcp://0.0.0.0:9292"
set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:stage)
set :puma_threads, -> { fetch(:stage).to_s == "staging" ? [0, 2] : [0, 16] }
set :puma_workers, -> { fetch(:stage).to_s == "staging" ? 1 : 2 }
set :puma_init_active_record, true
set :puma_preload_app, true
set :nginx_use_ssl, false
set :puma_worker_timeout, 30

set :bundle_binstubs, false
set :bundle_flags, "--deployment"

set :foreman_sudo, true
set :foreman_env, -> { "#{release_path}/#{fetch(:stage)}.env" }

set :slack_url, 'https://hooks.slack.com/services/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'
set :slack_channel, '#project-prime'
set :slack_user, -> { ENV["CI"] ? "ci" : (ENV["USER"] || ENV["USERNAME"]) }

set :whenever_environment, ->{ fetch(:stage) }
set :whenever_roles, ->{ :app }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

set :sidekiq_queue, {
  default: :web,
  daily_report: :web,
  publishers: :web,
  migration: :migration,
  etl: :etl,
  car_publisher: :car_publisher
}

set :sidekiq_concurrency, -> { fetch(:stage).to_s == "staging" ? 5 : nil }

namespace :deploy do
  before :starting, :check_authorities do
    authorities_file_path = "#{__dir__}/authorities.yml"
    authority_roles_file_path = "#{__dir__}/authority_roles.yml"

    authorities = YAML.load_file(authorities_file_path)
                      .each_with_object([]) { |(_, value), arr| arr << value.keys }
                      .flatten!.uniq.sort

    role_authorities = YAML.load_file(authority_roles_file_path)
                           .each_with_object([]) { |(_, hash), arr| arr << hash.fetch("authorities").split(" ") }
                           .flatten!.uniq.sort

    unless authorities == role_authorities
      arr_diff1 = authorities - role_authorities
      arr_diff2 = role_authorities - authorities

      message = <<-TXT

--------------------------权限有问题, 请校验-----------------------------------------
hint:
  我们有两个权限文件,
    所有权限列表(#{authorities_file_path})
    默认分配的角色权限列表(#{authority_roles_file_path})

出现这种情况, 一般是你新加了权限, 但是这个权限在两个文件中不匹配

      TXT

      message << "权限角色表中缺少 #{arr_diff1.join(', ')} \n" if arr_diff1.present?
      message << "权限表中缺少 #{arr_diff2.join(', ')} \n" if arr_diff2.present?

      abort(message)
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'unicorn:restart'
      # invoke 'foreman:restart'
    end

    invoke 'whenever:update_crontab'
    invoke 'sidekiq:restart'
  end

  after :restart, :"puma:restart"
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
    end
  end

  desc 'Upload config files'
  task :config do
    on roles(:app) do
      unless test "grep -Fxq \"rvm_trust_rvmrcs_flag=1\" ~/.rvmrc"
        execute "echo rvm_trust_rvmrcs_flag=1 >> ~/.rvmrc && source ~/.rvmrc"
      end

      execute "mkdir -p #{deploy_to}/shared/config/{pingpp,chejianding}"

      upload! File.new('config/database.example.yml'), "#{deploy_to}/shared/config/database.yml"
      upload! File.new('config/secrets.example.yml'), "#{deploy_to}/shared/config/secrets.yml"
      upload! File.new('config/application.example.yml'), "#{deploy_to}/shared/config/application.yml"

      %w(
        chejianding/rsa_public_key chejianding/rsa_private_key
        pingpp/rsa_public_key pingpp/rsa_private_key pingpp/pingpp_rsa_public_key
      ).each do |file_name|
        file_path = "config/#{file_name}.example.pem"
        target_path = "#{deploy_to}/shared/config/#{file_name}.pem"

        upload! File.new(file_path), target_path
      end

      # upload! File.new('config/unicorn.example.rb'), "#{deploy_to}/shared/config/unicorn.rb"
      info "Now edit the config files in #{shared_path}/config."
    end
  end
end

namespace :rake do
  desc "Import region data."
  task :region do
    on roles(:app) do
      execute "cd #{deploy_to}/current; rake region:import"
    end
  end
end

set :git_branch, ask("请输入部署分支: ", `git branch | sed -n '/\* /s///p'`.chomp.strip)
set :formatted_git_branch, -> { fetch(:git_branch).gsub("_", "-") }

set :docker_db_username, "deploy"
set :docker_db_password, -> { "CBbEseWD7CXc7PAuk" }
set :docker_root_path, -> { "prime-server/#{fetch(:formatted_git_branch)}" }
set :docker_nginx_conf_name, -> {
  [
    fetch(:formatted_git_branch).gsub("-", "_"),
    "docker_nginx_conf"
  ].join("_")
}
set :docker_rails_port, ask("请输入rails应用占用端口号: ", "9292")

namespace :docker do
  desc "init the project"
  task :init do
    on roles(:app) do
      execute <<-BASH.squish!
        sudo mkdir -p #{fetch(:docker_root_path)}/{#{fetch(:application)},redis,memcached,postgres}/tmp/{pids,sockets}
        && sudo chown -R deploy #{fetch(:docker_root_path)}
        && cd #{fetch(:docker_root_path)}
        && sudo rm -rf #{fetch(:application)}
        && git clone git@git.che3bao.com:autobots/prime-server.git -b #{fetch(:git_branch)}
        && cd #{fetch(:application)}
        && cp config/database.example.yml config/database.yml
        && cp config/application.example.yml config/application.yml
        && cp config/secrets.example.yml config/secrets.yml
      BASH

      {
        "Dockerfile.erb"         => "Dockerfile",
        "memcached/Dockerfile"   => "memcached/Dockerfile",
        "postgres/Dockerfile"    => "postgres/Dockerfile",
        "redis/Dockerfile"       => "redis/Dockerfile",

        "docker-compose.yml.erb" => "docker-compose.yml",
        "docker_nginx_conf.erb"  => fetch(:docker_nginx_conf_name)
      }.each do |template, file_name|
        template_path = File.expand_path(
          "../deploy/templates/#{template}", __FILE__
        )

        upload!(
          StringIO.new(ERB.new(File.read(template_path)).result(binding)),
          "#{fetch(:docker_root_path)}/#{file_name}"
        )
      end

      # copy ssh-key
      execute "cp ~/.ssh/docker ./#{fetch(:docker_root_path)}"

      # build docker
      execute "cd #{fetch(:docker_root_path)} && sudo docker-compose build"

      # Set up application.yml because of the redis connection for sidekiq.
      # execute <<-BASH.squish!
      #   cd #{fetch(:docker_root_path)}
      #   && sed -i "s/REDIS_1_PORT_6379_TCP_ADDR/$(
      #       sudo docker-compose run web env
      #         | grep _REDIS_1_PORT_6379_TCP_ADDR
      #         | grep -o '[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}'
      #     )/g" #{fetch(:application)}/config/application.yml
      # BASH

      execute <<-BASH.squish!
        cd #{fetch(:docker_root_path)}
        && echo yes | sudo docker-compose run web bundle install --without development test --deployment
        && sudo docker-compose run web ./bin/rake db:create
        && echo CBbEseWD7CXc7PAuk | sudo docker-compose run db psql -h db -U deploy -d prime_server_docker -f /pg_dump.sql
        && sudo docker-compose run web ./bin/rake db:create db:migrate
      BASH

      # && sed -i "s/DOCKER_URI/$(
      #     sudo docker-compose port web 3000
      #   )/g" #{fetch(:docker_nginx_conf_name)}
      execute <<-BASH.squish!
        cd #{fetch(:docker_root_path)}
        && sudo docker-compose start
        && cd /etc/nginx/sites-enabled/
        && sudo ln -sf /home/deploy/#{fetch(:docker_root_path)}/#{fetch(:docker_nginx_conf_name)}
        && sudo service nginx reload
      BASH

      execute <<-BASH.squish!
        cd #{fetch(:docker_root_path)} && sudo docker-compose restart
      BASH
    end
  end
end
