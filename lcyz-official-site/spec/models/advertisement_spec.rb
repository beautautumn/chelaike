# frozen_string_literal: true
# == Schema Information
#
# Table name: advertisements # 广告
#
#  id         :integer          not null, primary key
#  ad_type    :string                                 # 广告类型
#  image_url  :string                                 # 图片地址
#  link       :string                                 # 广告链接地址
#  tenant_id  :integer                                # 所归属租户
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  platform   :string                                 # 平台类型(移动/桌面)
#

require "rails_helper"

RSpec.describe Advertisement, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
