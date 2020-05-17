# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  imageable_id   :integer                                # 多态ID
#  imageable_type :string                                 # 多态名
#  url            :string                                 # 图片URL
#  name           :string                                 # 名称
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location       :string                                 # 图片位置
#  is_cover       :boolean          default(FALSE)        # 是否为LOGO
#  sort           :integer          default(0)            # 排序
#  image_style    :string                                 # 图片的类型
#

class Image < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :imageable, polymorphic: true, counter_cache: true
  # validations ...............................................................
  validates :url, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  scope :default_order, lambda {
    order(:sort).order(location_order_sql.squish!).order(:id)
  }

  scope :with_style, lambda { |style = nil|
    where(image_style: style)
  }
  # additional config .........................................................
  enum image_style: { alliance: "alliance", maintenance: "maintenance" }
  # class methods .............................................................
  def self.location_order_sql
    conditions = I18n.t("image.locations").map.with_index do |location, index|
      "when '#{location}' then #{index + 1}"
    end

    <<-ORDER_SQL
      case location
      #{conditions.join(" ")}
      else #{conditions.size + 1}
      end
    ORDER_SQL
  end

  def with_water_mark(position, water_mark_url)
    Util::WaterMark.make_for(url, position, water_mark_url)
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
