namespace :che3bao do
  desc "将车3宝中的图片路径改成阿里云"

  task image_reupload: :environment do
    def upload(url)
      connection = CarrierWave::Storage::Aliyun::Connection.new(
        AliyunOss.opts.merge!(aliyun_host: ENV.fetch("OSS_BUCKET_HOST_INTERNAL"))
      )

      filename = "#{ENV["OSS_IMAGE_FOLDER"]}/#{SecureRandom.hex}#{File.extname(url)}"

      io = open(url)
      content = io.class == StringIO ? io.read : io
      connection.put(filename, content)
      GC.start

      "#{ENV.fetch("IMAGE_HOST")}/#{filename}"
    end

    def execute
      Image.where("url not like 'http://image.che3bao.com/%'")
           .where("url not like '#{ENV.fetch("IMAGE_HOST")}%'")
           .where("url not like 'http://static.chelaike.che3bao.com%'")
           .find_each do |image|
        begin
          image.update!(url: upload(image.url))
        rescue ArgumentError => e
          if e.message == "string contains null byte"
            puts "删除图片#{image.id}"
            puts image.url

            image.destroy
          end
        rescue Errno::ENOENT
          image.destroy
        rescue StandardError => e
          puts e.exception.class
          puts e.message
        end
      end
    end

    loop do
      puts "checking"
      count = Image.where("url not like 'http://image.che3bao.com/%'")
                   .where("url not like '#{ENV.fetch("IMAGE_HOST")}%'")
                   .where("url not like 'http://static.chelaike.che3bao.com%'")
                   .count

      if count > 0
        puts "还剩下#{count}张图片"

        execute
      end

      puts "start sleepping"
      sleep 10.minutes
    end
  end
end
