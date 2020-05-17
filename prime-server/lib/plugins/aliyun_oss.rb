class AliyunOss
  attr_reader :oss_policy, :signature

  def initialize
    @oss_policy = self.class.oss_policy
  end

  # 阿里云oss直传签名所需的policy
  def self.oss_policy
    policy_hash = {
      expiration: (Time.zone.now + 24.hours).utc.iso8601(3),
      conditions: [{ bucket: bucket_name }]
    }

    # urlsafe的方式base64编码policy
    Base64.urlsafe_encode64(policy_hash.to_json).strip
  end

  def sign!
    hmac = OpenSSL::HMAC.digest(
      OpenSSL::Digest.new("sha1"),
      self.class.secret,
      oss_policy
    )

    @signature = Base64.encode64(hmac).strip

    self
  end

  def self.put_assets(io_or_path, filename, options = {})
    connection = CarrierWave::Storage::Aliyun::Connection.new(opts)

    forder = options.fetch(:forder, ENV.fetch("OSS_ASSET_FOLDER"))
    filename = URI.encode("#{forder}/#{filename}")

    content_type = Rack::Mime.mime_type(File.extname(filename))
    if io_or_path.respond_to?(:seek)
      connection.put(filename, io_or_path.string, content_type: content_type)
    else
      connection.put(filename, open(io_or_path), content_type: content_type)

      GC.start
    end

    "#{ENV.fetch("ASSET_HOST")}/#{filename}"
  end

  def self.put(path, filename = "")
    return "#{ENV.fetch("IMAGE_HOST")}/#{filename}" if Rails.env.dokku?

    connection = CarrierWave::Storage::Aliyun::Connection.new(opts)

    filename = "#{SecureRandom.hex}.jpg" if filename.empty?
    filename = "#{ENV.fetch("OSS_IMAGE_FOLDER")}/#{filename}"

    connection.put(filename, open(path))
    GC.start

    "#{ENV.fetch("IMAGE_HOST")}/#{filename}"
  end

  def self.get(path)
    return "#{ENV.fetch("IMAGE_HOST")}/#{filename}" if Rails.env.dokku?

    connection = CarrierWave::Storage::Aliyun::Connection.new(opts)

    path = "#{ENV.fetch("OSS_IMAGE_FOLDER")}/#{path}"
    connection.get(path)

    "#{ENV.fetch("OSS_BUCKET_HOST")}/#{path}"
  end

  def self.batch_download(zip_file, paths)
    index = 1

    Zip::OutputStream.open(zip_file) do |zos|
      paths.each do |path|
        filename = path.match(%r{(.*\/)*([^.]+.*)}).captures.second

        watermark = filename.match(/(.*)@watermark.*/)
        filename = watermark[1] if watermark

        begin
          name = "#{index}#{File.extname(filename)}"

          zos.put_next_entry(name)
          Timeout.timeout(3) do
            zos.print(open(path).read)
          end

          index += 1
        rescue
          next
        end
      end
    end
  end

  def self.opts
    {
      aliyun_access_id: key,
      aliyun_access_key: secret,
      aliyun_bucket: bucket_name,
      aliyun_area: area,
      aliyun_host: bucket_path
    }
  end

  def self.bucket_path
    ENV.fetch("OSS_BUCKET_HOST")
  end

  def self.bucket_name
    ENV.fetch("OSS_BUCKET_NAME")
  end

  def self.key
    ENV.fetch("ACCESS_KEY_ID")
  end

  def self.secret
    ENV.fetch("ACCESS_KEY_SECRET")
  end

  def self.area
    ENV.fetch("OSS_AREA")
  end

  def self.asset_host
    ENV.fetch("ASSET_HOST")
  end

  def self.oss_client
    @_oss_client ||= Aliyun::OSS::Client.new(
      endpoint: ENV.fetch("OSS_ENDPOINT"),
      access_key_id: ENV.fetch("ACCESS_KEY_ID"),
      access_key_secret: ENV.fetch("ACCESS_KEY_SECRET")
    )
  end

  def self.upload_by_io(filename, io_stream)
    bucket = oss_client.get_bucket(bucket_name)

    bucket.put_object(filename) { |stream| stream << io_stream }

    "#{ENV.fetch("IMAGE_HOST")}/#{filename}"
  end
end
