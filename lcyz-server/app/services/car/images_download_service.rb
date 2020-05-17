class Car < ActiveRecord::Base
  class ImagesDownloadService
    def initialize(user, car, urls)
      @user = user
      @urls = urls
      @car = car
    end

    def download
      file_name = @car.stock_number.gsub(/[^a-zA-Z0-9_-]/, "_")
      zip_file = "#{file_name}.zip"

      zip_path = ""
      io = StringIO.new

      Dir.mktmpdir do |dir|
        download_dir = "#{dir}/#{@car.id}"
        FileUtils.mkdir_p(download_dir) unless File.directory?(download_dir)

        zip_path = "#{download_dir}/zip_file"

        AliyunOss.batch_download(zip_path, @urls)

        io.puts open(zip_path).read
      end

      [zip_file, io]
    end
  end
end
