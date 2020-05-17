class PriceTagTemplate < ActiveRecord::Base
  class CreateService
    attr_reader :code, :dir_path, :aliyun_dir_name, :price_tag_template

    def initialize(user, file_path, original_filename, params = {})
      @user = user
      @file_path = file_path
      @basename = File.basename(original_filename, ".zip")
      @dir_path = File.join(
        Rails.root, "tmp", "files", "price_tag_templates",
        user.id.to_s, Time.zone.now.to_i.to_s
      )
      @aliyun_dir_name = File.join(
        ENV.fetch("OSS_PRICE_TAG_TEMPLATES"),
        SecureRandom.hex.to_s
      )
      @params = params
    end

    def execute
      unzip_file!
      upload_assets

      @code = replace_assets_path(
        File.join(@dir_path, @basename, "index.html")
      ).to_s.strip

      backup = @params[:name] == "默认模板" ? ENV.fetch("DEFAULT_TEMPLATE_URL") : nil

      @price_tag_template = PriceTagTemplate
                            .where(company_id: @user.company_id)
                            .create(
                              name: @params[:name],
                              code: @code,
                              backup: backup,
                              note: @params[:note]
                            )

      self
    end

    def aliyun_dir_path
      "#{AliyunOss.asset_host}/#{@aliyun_dir_name}"
    end

    def self.upload(asset_path, dir_name)
      connection = CarrierWave::Storage::Aliyun::Connection.new(AliyunOss.opts)

      filename = File.join(dir_name, File.basename(asset_path))

      content_type = Rack::Mime.mime_type(File.extname(asset_path))
      connection.put(filename, open(asset_path), content_type: content_type)
      GC.start

      "#{ENV.fetch("ASSET_HOST")}/#{filename}"
    end

    private

    def unzip_file!
      Zip::File.open(@file_path) do |zip_file|
        zip_file.each do |f|
          f_path = File.join(@dir_path, f.name)
          FileUtils.mkdir_p(File.dirname(f_path))

          zip_file.extract(f, f_path) unless File.exist?(f_path)
        end
      end
    end

    def upload_assets
      %w(images css js).each do |type|
        asset_dir = File.join(@dir_path, @basename, type)

        Dir.glob("#{asset_dir}/*").each do |asset_path|
          replace_css_file(asset_path) if type == "css"

          self.class.upload(asset_path, "#{aliyun_dir_name}/#{type}")
        end
      end
    end

    def replace_assets_path(file_path)
      file = File.read(file_path)
      %w(images css js).each do |type|
        file = file.gsub(%r{./#{type}/}, "#{aliyun_dir_path}/#{type}/")
      end

      file
    end

    def replace_css_file(css_file)
      File.open(css_file, "r+") do |f|
        f.write(
          File.read(css_file).gsub(%r{../images/}, "#{aliyun_dir_path}/images/")
        )
      end
    end
  end
end
