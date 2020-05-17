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

# ad_type: 预留字段，对应设计中的一级广告、二级广告…
# TODO: 增加平台属性，移动/PC 端
class Advertisement < ApplicationRecord
  extend Enumerize
  extend EnumerizeWithGroups

  belongs_to :tenant

  enumerize :platform, in: %i(mobile desktop), scope: true
  enumerize :ad_type,
            in: %i(level_1 level_2 level_3
                   guides service),
            groups: {
              home: %i(level_1 level_2 level_3),
              guides: %i(guides),
              service: %i(service)
            }

  mount_uploader :image_url, ImageUploader

  enumerize :platform, in: %i(mobile desktop), scope: true
  enumerize :ad_type,
            in: %i(level_1 level_2 level_3
                   guides service),
            groups: {
              home: %i(level_1 level_2 level_3),
              guides: %i(guides),
              service: %i(service)
            }
end
