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

require "rails_helper"

RSpec.describe PlatformBrand, type: :model do
  fixtures :all

  let(:platform_ant_queen_honda) { platform_brands(:platform_ant_queen_honda) }
  let(:platform_cha_doctor) { platform_brands(:platform_cha_doctor) }
  let(:platform_dasheng) { platform_brands(:platform_dasheng) }

  describe ".platform_brand_price" do
    before do
      MaintenanceSetting.instance.update(chejianding_unit_price: 16)
    end

    it "根据平台跟品牌得到相应的价格" do
      [platform_ant_queen_honda, platform_cha_doctor, platform_dasheng].map(&:save)

      result = PlatformBrand.platform_brand_price(platform: :ant_queen, brand_code: 17, mode: "mix")
      expect(result).to eq 19

      result = PlatformBrand.platform_brand_price(platform: :cha_doctor)
      expect(result).to eq 14

      result = PlatformBrand.platform_brand_price(platform: :dasheng, brand_code: 16)
      expect(result).to eq 29

      result = PlatformBrand.platform_brand_price(platform: :che_jian_ding)
      expect(result).to eq 16
    end
  end
end
