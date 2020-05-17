# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "qiyuan-official-site"
set :repo_url, "git@47.93.47.14:7y/qiyuan-official-site.git"

# Default branch is :master
ask :branch, "master"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> do
  if fetch(:stage).to_s == "staging"
    "/home/deploy/projects/#{fetch(:application)}"
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

set :rvm_ruby_version, "2.3.0"

# set :unicorn_config_path, -> { "#{current_path}/config/unicorn.rb" }
# set :unicorn_pid, -> { "#{current_path}/tmp/pids/unicorn.pid" }

# DB SYNC
set :db_local_clean, true
set :disallow_pushing, true

# PUMA
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, -> { fetch(:stage).to_s == "prerelease" ? "tcp://0.0.0.0:9292" : "tcp://0.0.0.0:8182" }
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

# set :whenever_environment, ->{ fetch(:stage) }
# set :whenever_roles, ->{ :app }
# set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# set :sidekiq_queue, {
  # default: :official_site
# }

# set :sidekiq_concurrency, -> { fetch(:stage).to_s == "staging" ? 5 : nil }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # invoke 'unicorn:restart'
      # invoke 'foreman:restart'
    end

    # invoke 'whenever:update_crontab'
    # invoke 'sidekiq:restart'
  end

  after :finishing, :restart

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

      upload! File.new('config/database.example.yml'), "#{deploy_to}/shared/config/database.yml"
      upload! File.new('config/secrets.example.yml'), "#{deploy_to}/shared/config/secrets.yml"
      upload! File.new('config/application.example.yml'), "#{deploy_to}/shared/config/application.yml"

      %w(
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

set :git_branch, ask("请输入部署分支: ", `git branch | sed -n '/\* /s///p'`.chomp.strip)
set :formatted_git_branch, -> { fetch(:git_branch).gsub("_", "-") }
