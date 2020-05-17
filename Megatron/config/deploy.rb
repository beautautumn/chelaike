lock '3.4.0'

set :application, "Megatron"
set :repo_url, "git@git.chelaike.com:autobots/Megatron.git"
ask :branch, "master"
set :deploy_to, "/home/deploy/#{fetch(:application)}"

set :pty, true

set :linked_files, fetch(:linked_files, []).push("config/database.yml",
                                                 "config/mongoid.yml",
                                                 "config/secrets.yml")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache",
                                               "tmp/sockets", "vendor/bundle",
                                               "public/system")

set :keep_releases, 5

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:stage)
set :puma_threads, [0, 16]
set :puma_workers, -> { fetch(:puma_env).to_s == "production" ? 3 : 2}
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, true
set :nginx_use_ssl, false

set :rvm_ruby_version, "2.2.4"

set :bundle_binstubs, false

namespace :deploy do

  desc 'Restart application'
  task :restart do
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
      unless File.read(File.expand_path("~/.rvmrc")) =~ /rvm_trust_rvmrcs_flag=1/
        execute "echo rvm_trust_rvmrcs_flag=1 >> ~/.rvmrc"
      end

      execute "mkdir -p #{deploy_to}/shared/config"
      upload! File.new('config/database.example.yml'), "#{deploy_to}/shared/config/database.yml"
      upload! File.new('config/secrets.example.yml'), "#{deploy_to}/shared/config/secrets.yml"
      upload! File.new('config/mongoid.example.yml'), "#{deploy_to}/shared/config/mongoid.yml"
      info "Now edit the config files in #{shared_path}/config."
    end
  end

end
