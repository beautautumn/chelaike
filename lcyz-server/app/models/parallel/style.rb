# == Schema Information
#
# Table name: parallel_styles # 平行进口车和厂家特价车的车型
#
#  id                    :integer          not null, primary key # 平行进口车和厂家特价车的车型
#  name                  :string                                 # 车型名称
#  origin                :string                                 # 原产地
#  color                 :string                                 # 颜色
#  configuration         :text                                   # 配置信息
#  status                :string                                 # 状态(现车, 报关中, etc)
#  suggested_price_cents :integer                                # 同款新车指导价
#  sell_price_cents      :integer                                # 港口自提价/销售成交价
#  style_type            :string                                 # 平行进口车/厂家特价车
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  parallel_brand_id     :integer                                # 品牌
#  images_count          :integer          default(0)            # 图片数量
#

class Parallel::Style < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :brand, class_name: "Parallel::Brand",
                     foreign_key: :parallel_brand_id,
                     counter_cache: true

  has_many :images, -> { with_style.default_order }, as: :imageable, class_name: Image.name
  # validations ...............................................................
  validates :name, presence: true
  validates :style_type, presence: true
  validates :parallel_brand_id, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :suggested_price, :sell_price
  accepts_nested_attributes_for :images, allow_destroy: true
  # 平行进口车 厂家特价车
  enumerize :style_type,
            in: %i(parallel_import special_offer)
  # class methods .............................................................
  # public instance methods ...................................................
  def images=(files)
    files.each do |file|
      if file.is_a? ActionDispatch::Http::UploadedFile
        url = upload_image(file)
        images.create!(url: url)
      else
        super
      end
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def upload_image(uploaded_file)
    connection = CarrierWave::Storage::Aliyun::Connection.new(AliyunOss.opts)
    extname = File.extname(uploaded_file.tempfile.path)
    filename = "parallel_styles/#{SecureRandom.hex}#{extname}"
    connection.put(filename, uploaded_file.tempfile, content_type: uploaded_file.content_type)
    GC.start
    "#{ENV.fetch("IMAGE_HOST")}/#{filename}"
  end
end
