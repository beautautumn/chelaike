# frozen_string_literal: true
# == Schema Information
#
# Table name: wechat_messages # 微信消息
#
#  id           :integer          not null, primary key
#  key          :string                                 # 事件key
#  app_id       :string                                 # 微信公众号 app_id
#  message_type :string                                 # 消息类型
#  content      :jsonb                                  # 消息内容
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class WechatMessage < ApplicationRecord
  include ::Wechat::Reply

  belongs_to :wechat_app, primary_key: :app_id, foreign_key: :app_id

  validates :key, uniqueness: { scope: :app_id }

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
end
