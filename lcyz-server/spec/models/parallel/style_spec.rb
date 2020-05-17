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

require "rails_helper"

RSpec.describe User do
  fixtures :all
  let(:q7) { parallel_styles(:q7) }
  let(:image_1) { images(:parallel_aodi_q7_image_1) }

  it "gets images and count" do
    expect(q7.images_count).to eq 2
    expect(q7.images).to include image_1
  end
end
