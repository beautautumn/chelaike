# == Schema Information
#
# Table name: easy_loan_loan_bills # 借款单
#
#  id                           :integer          not null, primary key # 借款单
#  company_id                   :integer                                # 借款公司
#  car_id                       :integer                                # 用哪辆车进行借款
#  sp_company_id                :integer                                # 通过哪家sp公司
#  funder_company_id            :integer                                # 提供资金公司
#  car_basic_info               :jsonb                                  # 冗余车辆基本信息
#  state                        :string                                 # 借款单当前状态
#  state_history                :jsonb                                  # 状态变更历史记录概要
#  apply_code                   :string                                 # 申请编号
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  estimate_borrow_amount_cents :integer          default(0)            # 预计申请借款金额
#  borrowed_amount_cents        :integer          default(0)            # 实际申请借款金额
#

class EasyLoan::LoanBill < ActiveRecord::Base
  # accessors .................................................................
  STATE_TEXT = {
    borrow_applied: "借款申请",
    borrow_submitted: "借款提交",
    reviewed: "借款审核",
    borrow_confirmed: "已放款",
    borrow_refused: "已拒绝",
    return_applied: "还款申请",
    return_submitted: "还款提交",
    return_confirmed: "还款确认",
    closed: "已关闭",
    canceled: "已取消"
  }.freeze

  CarBasicInfo = Struct.new(:vin, :name, :key_count)
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :company
  belongs_to :car
  belongs_to :sp_company, class_name: "EasyLoan::SpCompany"
  belongs_to :funder_company

  has_many :loan_bill_histories, -> { order(created_at: :desc) },
           foreign_key: :easy_loan_loan_bill_id,
           class_name: "EasyLoan::LoanBillHistory"
  has_many :operation_records, -> { order("id desc") },
           as: :targetable,
           class_name: "::OperationRecord"
  has_many :easy_loan_operation_records, -> { order("id desc") },
           as: :targetable,
           class_name: "EasyLoan::OperationRecord"

  # validations ...............................................................
  # callbacks .................................................................
  before_create :generate_code
  before_save :set_state_history
  # scopes ....................................................................
  scope :easy_loas_user_bills, ->(city) { joins(:company).where("companies.city" => city) }
  # additional config .........................................................
  delegate :shop_id, to: :car
  delegate :name, to: :funder_company, prefix: true
  delegate :name, to: :company, prefix: true

  # 借款申请，借款提交，借款审核，已放款，已拒绝，还款申请，还款提交，
  # 还款确认，已关闭, 已取消
  enumerize :state,
            in: %i(
              borrow_applied borrow_submitted reviewed
              borrow_confirmed borrow_refused
              return_applied return_submitted return_confirmed closed
              canceled
            )

  price_wan :estimate_borrow_amount, :borrowed_amount
  # class methods .............................................................
  # public instance methods ...................................................

  def car_cover_image_url
    car.cover_url
  end

  def latest_state_history
    loan_bill_histories.order(created_at: :desc).first
  end

  def state_text
    STATE_TEXT.fetch(state.to_sym, "无状态")
  end

  def state_message_text
    return "#{borrowed_amount_wan}万" if borrowed_amount_cents?
    return "#{estimate_borrow_amount_wan}万" if estimate_borrow_amount_cents?
  end

  def images
    transfer_record = car.acquisition_transfer
    return [] unless transfer_record
    image_locations_hash = {
      driving_license: "行驶证",
      registration_license: "登记证",
      insurance: "保单"
    }

    images = image_locations_hash.inject([]) do |acc, image_location_arr|
      location = image_location_arr.first
      location_text = image_location_arr.last
      acc << transfer_record.images.where(location: [location.to_s, location_text]).first
    end

    images.compact
  end

  def accredited_record
    EasyLoan::AccreditedRecord.where(
      funder_company_id: funder_company_id,
      company_id: company_id
    ).first
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def generate_code
    last_5_digits = rand(10**5).to_s.rjust(5, "0")
    apply_code = "6#{last_5_digits}"
    generate_code if self.class.exists?(apply_code: apply_code)
    self.apply_code = apply_code
  end

  def set_state_history
    return unless state_changed?
    self.state_history ||= {}
    self.state_history["#{state}_at"] = Time.zone.now
  end
end
