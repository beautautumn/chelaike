# == Schema Information
#
# Table name: easy_loan_operation_records # 车融易用户操作记录
#
#  id                    :integer          not null, primary key # 车融易用户操作记录
#  targetable_id         :integer                                # 操作对象
#  targetable_type       :string                                 # 操作对象
#  operation_record_type :string                                 # 事件类型
#  user_id               :integer                                # 操作人ID
#  messages              :jsonb                                  # 操作信息
#  sp_company_id         :integer                                # 对应所属sp公司
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_type             :string                                 # 操作人多态
#  detail                :jsonb                                  # 操作记录详情
#

require "rails_helper"

RSpec.describe EasyLoan::OperationRecord, type: :model do
end
