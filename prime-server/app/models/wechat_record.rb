# == Schema Information
#
# Table name: wechat_records
#
#  id         :integer          not null, primary key
#  app_id     :string                                 # 微信app_id
#  open_id    :string                                 # 微信用户open id
#  action     :string                                 # 操作
#  data       :jsonb                                  # 数据记录
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WechatRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :wechat_user, primary_key: :open_id, foreign_key: :open_id
  belongs_to :wechat_app, primary_key: :app_id, foreign_key: :app_id
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :action, in: %i(scan subscribe)
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
