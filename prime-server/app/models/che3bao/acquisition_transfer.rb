# == Schema Information
#
# Table name: tf_b_buy
#
#  id               :integer          not null, primary key
#  corp_id          :integer
#  depart_id        :integer
#  buy_staff        :integer
#  stock_id         :integer
#  buy_price        :integer
#  buy_date         :date                                   # 确认收购的日期
#  buy_state        :string(1)                              # 0：失效；1：生效
#  state_desc       :string(255)
#  deal_adjust_desc :string(255)
#  create_time      :datetime
#  update_time      :datetime
#  refund_price     :integer
#  refund_time      :date
#  refund_staff     :integer
#  pay_state        :string(1)
#  we_funds         :integer
#  other_funds      :integer
#  consign_person   :string(40)
#  consign_tel      :string(40)
#  consign_price    :integer
#

module Che3bao
  class AcquisitionTransfer < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    belongs_to :corp
    belongs_to :stock

    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_b_buy"
    # class methods .............................................................
    # public instance methods ...................................................
    def acquired_at
      buy_date.present? ? buy_date : stock.create_time
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
