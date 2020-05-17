# == Schema Information
#
# Table name: wechat_users # 微信用户
#
#  id            :integer          not null, primary key # 微信用户
#  open_id       :string                                 # 微信用户open id
#  wechat_app_id :integer                                # 微信应用ID
#  subscribed    :boolean                                # 用户是否关注该应用
#  nick_name     :string                                 # 微信昵称
#  gender        :string                                 # 用户性别
#  city          :string                                 # 所在城市
#  province      :string                                 # 所在省份
#  country       :string                                 # 所在国家
#  avatar        :string                                 # 头像
#  note          :string                                 # 备注
#  group_code    :integer                                # 所在分组ID
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  unionid       :string
#

class WechatUser < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :wechat_app
  has_many :wechat_records, primary_key: :open_id, foreign_key: :open_id
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def subscribe
    self.subscribed = true
  end

  def unsubscribe
    self.subscribed = false
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
