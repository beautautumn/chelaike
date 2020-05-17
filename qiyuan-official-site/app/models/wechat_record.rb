# frozen_string_literal: true
# == Schema Information
#
# Table name: wechat_records # 微信操作记录
#
#  id                          :integer          not null, primary key
#  wechat_app_user_relation_id :integer
#  action                      :string                                 # 操作
#  data                        :jsonb                                  # 数据记录
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class WechatRecord < ApplicationRecord
  extend Enumerize
  belongs_to :wechat_user_app_relation
  has_one :wechat_app, through: :wechat_user_app_relation
  has_one :wechat_user, through: :wechat_user_app_relation

  enumerize :action, in: %i(scan subscribe)
end
