# == Schema Information
#
# Table name: token_bills # 车币账单
#
#  id                 :integer          not null, primary key # 车币账单
#  state              :string                                 # 车币支付状态
#  action_type        :string                                 # 事件类型
#  payment_type       :string                                 # 收支类型
#  amount             :integer                                # 金额
#  operator_id        :integer                                # 事件的操作人
#  action_abstraction :jsonb                                  # 事件的概要描述
#  owner_id           :integer                                # Token的拥有者，可能为公司或个人
#  token_type         :string                                 # token类型
#  company_id         :integer                                # 操作人所属公司
#  shop_id            :integer                                # 操作人所属店铺
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TokenBill < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :operator, class_name: "User"
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :state, in: %i(pending finished) # 待支付，已完成

  # 充值,查询维保记录,维保记录退款
  enumerize :action_type,
            in: %i(charge maintenance_query maintenance_refund insurance_query
                   insurance_refund)
  enumerize :token_type, in: %i(company user)

  # 收入，支出
  enumerize :payment_type, in: %i(income payout)

  # class methods .............................................................
  class << self
    def get_bills(obj)
      case obj
      when User
        where(token_type: "user", owner_id: obj.id)
      when Company
        where(token_type: "company", owner_id: obj.id)
      end
    end
  end
  # public instance methods ...................................................
  def date_str
    Util::Date.token_bill_date(created_at)
  end

  def time_str
    Util::Date.token_bill_time(created_at)
  end

  def month_str
    if created_at.to_date.in?(Time.zone.today.beginning_of_month..Time.zone.today.end_of_month)
      "本月"
    else
      created_at.strftime("%m月")
    end
  end

  def format_json
    attributes.merge(
      date_str: date_str,
      time_str: time_str
    )
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
