# == Schema Information
#
# Table name: operation_records # 操作历史
#
#  id                    :integer          not null, primary key # 操作历史
#  targetable_id         :integer                                # 多态ID
#  targetable_type       :string                                 # 多态类型
#  operation_record_type :string                                 # 事件类型
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer                                # 操作人ID
#  messages              :jsonb                                  # 操作信息
#  company_id            :integer                                # 公司ID
#  shop_id               :integer                                # 店ID
#  detail                :jsonb                                  # 详情
#

module OperationRecordSerializer
  class Common < ActiveModel::Serializer
    include SerializerAuthorityHelper

    attributes :id, :operation_record_type, :user_id, :name, :created_at, :messages,
               :company_id, :operation_record_type_color, :detail_text,
               :operation_record_type_icon

    def name
      object.messages["user_name"]
    end

    def detail_text
      object.detail_text(scope)
    end

    def messages
      messages = object.messages

      case object.operation_record_type
      when "car_priced"
        messages.except!(
          "previous_sales_minimun_price_wan", "sales_minimun_price_wan"
        ) unless User::Pundit.filter(scope, object.targetable, ["销售底价查看"])

        messages.except!(
          "previous_manager_price_wan", "manager_price_wan"
        ) unless User::Pundit.filter(scope, object.targetable, ["经理底价查看"])
      end

      messages
    end
  end
end
