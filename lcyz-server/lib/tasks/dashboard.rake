namespace :dashboard do
  desc "上传静态文件: rake dashboard:upload assets_path=xxx assets_filename=xxx"
  task upload: :environment do |_t, _args|
    path = ENV["assets_path"]
    filename = ENV["assets_filename"]

    puts AliyunOss.put_assets(path, filename)
  end
end
