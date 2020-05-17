namespace :postgre do
  desc "dump数据"
  task dump: :environment do
    pg_password = ENV["PRIME_DATABASE_PASSWORD"]
    pg_dump_sql = "#{Rails.root}/tmp/pg_dump.sql"
    dump_cmd = <<-BASH
      PGPASSWORD=#{pg_password}
      pg_dump
        -h prime.lina.che3bao.com
        -U deploy
        -F c
        -d prime_server_staging
      > #{pg_dump_sql}
    BASH

    system "rm #{pg_dump_sql}"
    system dump_cmd.squish
    puts "done!"
  end
end
