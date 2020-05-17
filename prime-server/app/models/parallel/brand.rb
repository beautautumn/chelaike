# == Schema Information
#
# Table name: parallel_brands # 平行进口车和厂家特价车的品牌
#
#  id           :integer          not null, primary key # 平行进口车和厂家特价车的品牌
#  name         :string                                 # 品牌名称
#  logo_url     :string                                 # LOGO 图片 URL
#  order        :integer                                # 排序
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  brand_type   :string                                 # 品牌类型(平行进口车/厂家特价车)
#  styles_count :integer          default(0)            # 车型数量
#

class Parallel::Brand < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  has_many :styles, class_name: "Parallel::Style",
                    foreign_key: :parallel_brand_id
  # validations ...............................................................
  validates :name, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :hot, -> { order("styles_count DESC") }
  # additional config .........................................................
  # 平行进口车 厂家特价车
  enumerize :brand_type,
            in: %i(parallel_import special_offer)
  # class methods .............................................................
  # public instance methods ...................................................
  def first_letter
    Util::Brand.to_pinyin(name).upcase
  end

  def logo_url=(url)
    if url.is_a? ActionDispatch::Http::UploadedFile
      super(upload_logo(url))
    else
      super
    end
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
