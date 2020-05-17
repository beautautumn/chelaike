# == Schema Information
#
# Table name: detection_configs # 检测报告平台配置
#
#  id            :integer          not null, primary key # 检测报告平台配置
#  platform_name :string                                 # 平台名
#  key           :string                                 # 平台key
#  c_id          :integer                                # 对应商家id
#  c_code        :string                                 # 商家code
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe DetectionConfig, type: :model do
  describe "#hash_code" do
    it "生成key和c_code" do
      config = DetectionConfig.create!(platform_name: "bihu", c_id: 1)
      expect(config.key).to be_present
    end
  end
end
