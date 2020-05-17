# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  name       :string
#  alias      :string
#  logo       :string
#  slogan     :string
#  domain     :string
#  pc_url     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class App < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  has_many :app_versions
  # validations ...............................................................
  validates :name, :alias, :domain, :slogan, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def logo=(url)
    if url.is_a? ActionDispatch::Http::UploadedFile
      super(upload_logo(url))
    else
      super
    end
  end

  def latest_version(version_type)
    app_versions.where(version_type: version_type)
                .order(version_number: :desc)
                .limit(1)
                .first
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def upload_logo(uploaded_file)
    connection = CarrierWave::Storage::Aliyun::Connection.new(AliyunOss.opts)
    extname = File.extname(uploaded_file.tempfile.path)
    filename = "app_logos/#{SecureRandom.hex}#{extname}"
    connection.put(filename, uploaded_file.tempfile, content_type: uploaded_file.content_type)
    "#{ENV.fetch("ASSET_HOST")}/#{filename}"
  end
end
