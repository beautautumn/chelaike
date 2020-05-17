# == Schema Information
#
# Table name: tf_t_stock_reserv
#
#  reserv_id    :integer          not null, primary key
#  stock_id     :integer
#  deal_staff   :integer
#  source_code  :integer
#  cancel_staff :integer
#  region_code  :integer
#  sale_kind    :string(1)
#  deal_date    :date
#  deal_price   :integer
#  front_money  :integer
#  other_desc   :string(255)
#  valid_tag    :string(1)
#  create_time  :datetime         not null
#  update_time  :datetime         not null
#  cancel_date  :date
#  cancel_price :integer
#  cancel_desc  :string(255)
#  cust_addr    :string(255)
#  cust_cert_no :string(40)
#  cust_tel     :string(40)
#  cust_name    :string(40)
#

module Che3bao
  class CarReservation < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    belongs_to :stock
    belongs_to :channel, foreign_key: :source_code, class_name: Channel.name
    belongs_to :seller, foreign_key: :deal_staff, class_name: Staff.name
    belongs_to :region, foreign_key: :region_code
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_t_stock_reserv"
    self.primary_key = "reserv_id"
    # class methods .............................................................
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
