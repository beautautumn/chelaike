# == Schema Information
#
# Table name: platform_brands
#
#  id                 :integer          not null, primary key
#  platform_code      :integer
#  brand_name         :string
#  brand_code         :string
#  price              :integer
#  start_time         :time
#  end_time           :time
#  need_engine_number :boolean
#  mode               :string
#  comment            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  status             :boolean          default(FALSE)
#

class PlatformBrand < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :valid, -> { where(status: true) }
  # additional config .........................................................
  # class methods .............................................................
  #
  # 蚂蚁女王 platform_code => 1
  # 查博士 platform_code => 2
  # 大圣来了 platform_code => 3
  # 车鉴定 platform_code => 4
  class << self
    def get_platform_brands(platform_code, mode = nil)
      if platform_code.to_i == 1
        mode = mode.to_i == 1 ? "text" : "mix"
        valid.where(platform_code: platform_code, mode: mode)
      else
        valid.where(platform_code: platform_code)
      end
    end

    def platform_brand_price(platform:, brand_code: nil, mode: nil)
      return MaintenanceSetting.instance.chejianding_unit_price if platform == :che_jian_ding
      platform_maps = {
        ant_queen: 1,
        cha_doctor: 2,
        dasheng: 3
      }

      brand_code = nil unless platform.in?(%i(ant_queen dasheng))

      platform_code = platform_maps.fetch(platform)
      record = valid.where(platform_code: platform_code, brand_code: brand_code, mode: mode).first

      record.price
    end
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
