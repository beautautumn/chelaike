namespace :etl do
  def sync(incremental: true)
    # targets = %w(car customer intention operation_record)
    targets = %w(car)
    targets.map do |name|
      env_commands = []
      env_commands << "ETL_INCREMENTAL=ON" if incremental

      env_commands = env_commands.join(" ")

      command = "#{env_commands} bundle exec kiba lib/plugins/etl/scripts/#{name}.etl"
      puts "read to execute `#{command}`"

      system(command)
    end
  end

  desc "同步etl数据"
  task execute: :environment do
    sync
  end

  desc "全量 ETL 处理"
  task sync_all: :environment do
    sync(incremental: false)
  end
end
