# == Schema Information
#
# Table name: wechat_messages
#
#  id           :integer          not null, primary key
#  key          :string                                 # 事件key
#  app_id       :string                                 # 微信公众号app id
#  message_type :string                                 # 消息类型
#  content      :jsonb                                  # 消息内容
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class WechatMessage < ActiveRecord::Base
  include ::Wechat::Reply
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :wechat_app, primary_key: :app_id, foreign_key: :app_id
  # validations ...............................................................
  validates :key, uniqueness: { scope: :app_id }
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def deliver_xml(from:, to:)
    case message_type
    when "text"
      reply_text_message(
        from: from,
        to: to,
        content: content["content"]
      )
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
