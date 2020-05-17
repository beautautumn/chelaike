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

class EasyLoan::AccreditedRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :company
  belongs_to :funder_company
  has_many :operation_records, -> { order("id desc") },
           as: :targetable,
           class_name: "::OperationRecord"
  has_many :accredited_record_histories,
           class_name: "EasyLoan::AccreditedRecordHistory"
  # validations ...............................................................
  # callbacks .................................................................
  before_update :record_history
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :limit_amount, :in_use_amount
  delegate :name, to: :funder_company, prefix: true
  # class methods .............................................................
  # public instance methods ...................................................

  def shop_id
    company.shops.first.id
  end

  # def funder_company_name
  #   EasyLoan::FunderCompany.find(funder_company_id).name
  # end

  def remaining_amount_wan
    used_amount_wan = in_use_amount_wan.to_f
    value = limit_amount_wan - used_amount_wan
    return 0 if value < 0
    value
  end

  def latest_limit_amout_wan
    accredited_record_histories.order(:created_at).last.try(:limit_amount_wan)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def record_history
    return unless limit_amount_cents_changed? || single_car_rate_changed?
    accredited_record_histories.create!(
      limit_amount_cents: limit_amount_cents,
      single_car_rate: single_car_rate
    )
  end
end
