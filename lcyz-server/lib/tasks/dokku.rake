namespace :dokku do
  namespace :ps do
    desc "显示所有 app 中的进程"
    task list: :environment do
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 设置 dokku remot
      system "git remote remove dokku"
      system "git remote add dokku dokku@dokku.puck.chelaike.com:#{app}"

      # 显示所有进程
      system "dokku ps"
    end
  end

  namespace :postgre do
    desc "上传seed数据"
    task upload: :environment do
      pg_dump_sql = "#{Rails.root}/tmp/pg_dump.sql"
      system "scp -r #{pg_dump_sql} deploy@puck:~/pg_dump/"
    end

    desc "删除数据库"
    task destroy: :environment do
      ssh_host = "dokku@dokku.puck.chelaike.com"
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 删除 PG
      system "echo #{app} | ssh -t #{ssh_host} postgres:destroy #{app}"
    end

    desc "导入seed"
    task import: :environment do
      ssh_host = "dokku@dokku.puck.chelaike.com"
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")
      pg_dump_sql = "#{Rails.root}/tmp/pg_dump.sql"

      system "ssh -t #{ssh_host} postgres:create #{app}"
      puts "start importing"
      system "ssh -t #{ssh_host} postgres:import #{app} < #{pg_dump_sql}"
    end
  end

  namespace :app do
    desc "显示所有 app"
    task list: :environment do
      ssh_host = "dokku@dokku.puck.chelaike.com"

      # 显示所有应用
      system "ssh -t #{ssh_host} apps"
    end

    desc "部署feature app"
    task deploy: :environment do
      ssh_host = "dokku@dokku.puck.chelaike.com"
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 设置 dokku remot
      system "git remote remove dokku"
      system "git remote add dokku dokku@dokku.puck.chelaike.com:#{app}"
      # 创建应用
      system "ssh -t #{ssh_host} apps:create #{app}"
      # 创建PG
      system "ssh -t #{ssh_host} postgres:create #{app}"
      system "ssh -t #{ssh_host} postgres:link #{app} #{app}"
      # 创建Redis
      system "ssh -t #{ssh_host} redis:create #{app}"
      system "ssh -t #{ssh_host} redis:link #{app} #{app}"
      # 创建Memcached
      system "ssh -t #{ssh_host} memcached:create #{app}"
      system "ssh -t #{ssh_host} memcached:link #{app} #{app}"
      # 设置环境变量
      env = [
        "REDIS_URL=redis://dokku-redis-#{app}:6379/0",
        "CACHE_HOST=memcached://dokku-memcached-#{app}:11211",
        "DOKKU_NGINX_PORT=80",
        "RAILS_ENV=dokku",
        "BUILDPACK_URL=https://github.com/Darmody/heroku-buildpack-ruby"
      ].join(" ")
      system "dokku config:set #{env}"
      # 部署代码
      system "git push dokku #{branch}:master -f"
      # 打开浏览器
      system "dokku open"
    end

    desc "重启feature app"
    task restart: :environment do
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 设置 dokku remot
      system "git remote remove dokku"
      system "git remote add dokku dokku@dokku.puck.chelaike.com:#{app}"
      # 重启
      system "dokku ps:restart"

      # 打开浏览器
      system "dokku open"
    end

    desc "删除feature app"
    task :destroy, [:branch] => :environment do |_t, args|
      ssh_host = "dokku@dokku.puck.chelaike.com"
      branch = args[:branch] || Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 设置 dokku remot
      system "git remote remove dokku"
      system "git remote add dokku dokku@dokku.puck.chelaike.com:#{app}"
      # 删除 app
      system "echo #{app} | ssh -t #{ssh_host} apps:destroy #{app}"

      # 删除 PG
      system "echo #{app} | ssh -t #{ssh_host} postgres:destroy #{app}"
      # 删除 Redis
      system "echo #{app} | ssh -t #{ssh_host} redis:destroy #{app}"
      # 删除 Memcached
      system "echo #{app} | ssh -t #{ssh_host} memcached:destroy #{app}"
    end

    desc "打开app console"
    task console: :environment do
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 设置 dokku remot
      system "git remote remove dokku"
      system "git remote add dokku dokku@dokku.puck.chelaike.com:#{app}"
      # 打开控制台
      system "dokku run rails c"
    end

    desc "feature app logs"
    task log: :environment do
      branch = Grit::Repo.new(Rails.root).head.name
      project = Rails.application.class.parent_name.downcase
      app = [branch, project].join("-")

      # 设置 dokku remot
      system "git remote remove dokku"
      system "git remote add dokku dokku@dokku.puck.chelaike.com:#{app}"
      # 重启
      system "dokku logs"
    end
  end
end
