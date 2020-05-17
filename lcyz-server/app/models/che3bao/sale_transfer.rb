# == Schema Information
#
# Table name: tf_s_sale
#
#  id               :integer          not null, primary key
#  corp_id          :integer
#  sale_staff       :integer
#  stock_id         :integer
#  deal_date        :date
#  sale_price       :integer
#  insur_fee        :integer
#  mortgage_fee     :integer
#  other_fee        :integer
#  sale_state       :string(1)                              # 0：失效；1：生效
#  state_desc       :string(255)
#  pay_model        :string(1)                              # 0：现款；1：贷款
#  deal_adjust_desc :string(255)
#  create_time      :datetime
#  update_time      :datetime         not null
#  mortgage_tag     :string(1)
#  refund_price     :integer
#  refund_time      :date
#  refund_desc      :string(255)
#  refund_staff     :integer
#  cust_source      :integer
#  rev_state        :string(1)
#  finance_date     :date
#  sale_kind        :string(1)
#  front_money      :integer
#  transfer_fee     :integer
#  comm_fee         :integer
#  region_id        :integer
#  cust_name        :string(40)
#  cust_tel_num     :string(40)
#  cust_cert_no     :string(40)
#  insur_tag        :string(1)
#  jqx_fee          :integer
#  syx_fee          :integer
#  mortgage_corp_id :integer
#  first_pay        :integer
#  loan_limit       :integer
#  deposit_fee      :integer
#  insur_corp_id    :integer
#  sale_remark      :string(255)
#  cust_addr        :string(255)
#  mortgage_month   :integer
#

module Che3bao
  class SaleTransfer < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    belongs_to :corp
    belongs_to :stock
    belongs_to :seller, foreign_key: :sale_staff, class_name: Staff.name
    belongs_to :channel, foreign_key: :cust_source, class_name: Channel.name
    belongs_to :region
    belongs_to :mortgage_company,
               foreign_key: :insur_corp_id,
               class_name: MortgageCompany.name
    belongs_to :insurance_company,
               foreign_key: :insur_corp_id,
               class_name: InsuranceCompany.name

    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_s_sale"
    # class methods .............................................................
    # public instance methods ...................................................
    def sales_type
      return unless sale_kind.present?

      sale_kind.to_i == 1 ? "wholesale" : "retail"
    end

    def payment_type
      return unless pay_model.present?

      pay_model.to_i == 0 ? "cash" : "mortgage"
    end

    def remaining_money_cents
      if sale_price && front_money
        sale_price - front_money
      end
    end

    def customer_location_province
      region.parent.region_name if region
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
