# frozen_string_literal: true
# == Schema Information
#
# Table name: wechat_users # 微信用户
#
#  id            :integer          not null, primary key
#  nick_name     :string                                 # 微信昵称
#  gender        :string                                 # 用户性别
#  city          :string                                 # 所在城市
#  province      :string                                 # 所在省份
#  country       :string                                 # 所在国家
#  avatar        :string                                 # 头像
#  note          :string                                 # 备注
#  union_id      :string                                 # Union ID
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  phone         :string                                 # 微信用户手机号
#  super_manager :boolean          default(FALSE)        # 是否是超级管理员
#

# 每个用户的基本信息和 union_id
# 在整个平台上，每个微信用户拥有唯一的 union_id 标识
# 未关注公众号的，拿不到昵称、性别、地区、头像
class WechatUser < ApplicationRecord
  has_many :wechat_app_user_relations, dependent: :destroy
  has_many :wechat_apps, through: :wechat_app_user_relations, source: :wechat_app
  has_many :favorite_cars
  has_many :enquiries

  def subscribe
    self.subscribed = true
  end

  def unsubscribe
    self.subscribed = false
  end
end
