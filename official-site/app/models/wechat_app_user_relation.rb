# frozen_string_literal: true
# == Schema Information
#
# Table name: wechat_app_user_relations # 微信用户与公众号关联表
#
#  id             :integer          not null, primary key
#  wechat_app_id  :integer                                # 公众号 ID
#  wechat_user_id :integer                                # 用户 ID
#  group_id       :integer                                # 分组 ID
#  open_id        :string                                 # 用户在每个公众号下的 Open ID
#  refresh_token  :string                                 # refresh_token
#  subscribed     :boolean                                # 用户是否关注该应用
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# 每个微信用户对每个公众号有不同的 OpenID
# 以后可能需要改成用户-车商(租户/网站)，因为许多车商没有公众号

class WechatAppUserRelation < ApplicationRecord
  belongs_to :wechat_app
  belongs_to :wechat_user
  has_many   :wechat_records
  has_many   :favorite_cars, through: :wechat_user
  has_many :enquiries, through: :wechat_user
  has_many :orders, primary_key: :open_id, foreign_key: :open_id

  delegate :nick_name, :gender, :city, :province, :country,
           :avatar, :note, :union_id, to: :wechat_user
  delegate :app_id, to: :wechat_app
end
