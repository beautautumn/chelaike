# frozen_string_literal: true
# == Schema Information
#
# Table name: wechat_apps # 微信应用
#
#  id                :integer          not null, primary key
#  app_id            :string                                 # 微信公众号app id
#  tenant_id         :integer                                # 租户 id
#  user_name         :string                                 # 微信公众号username
#  refresh_token     :string                                 # 重置令牌的token
#  authorities       :text             is an Array           # 可操作的app权限
#  nick_name         :string                                 # 授权方昵称
#  alias             :string                                 # 授权方公众号所设置的微信号
#  menus_state       :string                                 # 菜单存储状态
#  head_img          :string(500)
#  service_type_info :integer                                # 公众号类型
#  verify_type_info  :integer                                # 认证类型
#  business_info     :jsonb                                  # 功能的开通状况（0代表未开通，1代表已开通）
#  qrcode_url        :string(500)                            #  二维码图片的URL
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  state             :string           default("enabled")    # 应用状态
#

# 微信公众号
class WechatApp < ApplicationRecord
  extend Enumerize

  belongs_to :tenant
  has_many :wechat_app_user_relations, dependent: :destroy
  has_many :wechat_users, through: :wechat_app_user_relations, source: :wechat_user
  has_many :wechat_messages, primary_key: :app_id, foreign_key: :app_id, dependent: :delete_all
  has_many :wechat_records, through: :wechat_app_user_relations

  enumerize :state, in: %i(enabled disabled)

  # 前端菜单状态 编辑中 已发布
  enumerize :menus_state, in: %i(editing published), default: :editing

  # 授权方认证类型，-1代表未认证，0代表微信认证，1代表新浪微博认证，2代表腾讯微博认证，
  # 3代表已资质认证通过但还未通过名称认证，4代表已资质认证通过、还未通过名称认证，但通
  # 过了新浪微博认证，5代表已资质认证通过、还未通过名称认证，但通过了腾讯微博认证

  # 授权方公众号类型，0代表订阅号，1代表由历史老帐号升级后的订阅号，2代表服务号
  enumerize :service_type_info,
            in: { subscription: 0, old_subscription: 1, service: 2 }

  def verify_service?
    service_type_info.service? && verify?
  end

  def verify?
    verify_type_info.present? && verify_type_info >= 0
  end
end
