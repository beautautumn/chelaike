# frozen_string_literal: true
require "roxml"

# <xml>
#  <ToUserName><![CDATA[touser]]></ToUserName>
#  <FromUserName><![CDATA[fromuser]]></FromUserName>
#  <CreateTime>1399197672</CreateTime>
#  <MsgType><![CDATA[transfer_customer_service]]></MsgType>
#  <TransInfo>
#   <KfAccount>test1@test</KfAccount>
#  </TransInfo>
# </xml>

module Wechat
  module Message
    class TransferCustomerService < Base
      # rubocop:disable Style/VariableName
      def initialize
        super
        @MsgType = "transfer_customer_service"
      end
      # rubocop:enable Style/VariableName
    end
  end
end
