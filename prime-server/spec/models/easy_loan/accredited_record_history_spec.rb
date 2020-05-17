# == Schema Information
#
# Table name: easy_loan_accredited_record_histories # 记录授信变更历史
#
#  id                   :integer          not null, primary key # 记录授信变更历史
#  accredited_record_id :integer                                # 对应授信记录
#  limit_amount_cents   :integer                                # 变更前的授信金额
#  single_car_rate      :decimal(, )                            # 变更前的单车比例
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::AccreditedRecordHistory, type: :model do
end
