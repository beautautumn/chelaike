# == Schema Information
#
# Table name: easy_loan_accredited_records # 公司授信记录
#
#  id                  :integer          not null, primary key # 公司授信记录
#  company_id          :integer                                # 被授信车商公司id
#  limit_amount_cents  :integer          default(0)            # 额度
#  in_use_amount_cents :integer          default(0)            # 已用额度
#  funder_company_id   :integer                                # 资金方公司id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  single_car_rate     :decimal(, )                            # 单车借款比例
#  sp_company_id       :integer                                # 对应的sp公司
#

require "rails_helper"

RSpec.describe EasyLoan::AccreditedRecord, type: :model do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }

  describe "#before_update" do
    it "创建变更历史记录" do
      accredited_record = EasyLoan::AccreditedRecord.create!(
        company_id: tianche.id,
        funder_company_id: gmc.id,
        limit_amount_wan: 100,
        single_car_rate: 0.5
      )

      accredited_record.update!(
        limit_amount_wan: 120
      )

      expect(accredited_record.accredited_record_histories.count).to eq 1
    end
  end
end
