# == Schema Information
#
# Table name: tf_m_cust_followhis
#
#  follow_his_id     :integer          not null, primary key
#  invalid_reason_id :integer
#  defeat_reason_id  :integer
#  follow_staff      :integer
#  audit_id          :integer
#  cust_id           :integer
#  plan_follow_date  :date
#  next_follow_plan  :string(255)
#  follow_desc       :string(255)
#  follow_result     :string(10)
#  reserv_date       :datetime
#  deal_date         :date
#  follow_time       :datetime
#  create_time       :datetime         not null
#  update_time       :datetime         not null
#  next_follow_date  :date
#  follow_finish_tag :string(1)
#  deal_type         :string(1)
#  recv_tag          :string(1)
#

module Che3bao
  class IntentionPushHistory < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    belongs_to :customer, foreign_key: :cust_id
    belongs_to :invalid_reason
    belongs_to :defeat_reason
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_m_cust_followhis"
    self.primary_key = "follow_his_id"
    # class methods .............................................................
    # public instance methods ...................................................
    def state
      case follow_result
      when "dgj"
        "pending"
      when "yyy"
        "interviewed"
      when "ycj"
        "completed"
      when "gjz"
        "processing"
      when "ysk"
        "invalid"
      when "yzb"
        "failed"
      else
        "pending"
      end
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
