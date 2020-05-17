# == Schema Information
#
# Table name: tf_s_sale_source
#
#  sale_source_id      :integer          not null, primary key
#  cust_id             :integer
#  owner_staff         :integer
#  deal_stock          :integer
#  owner_corp          :integer
#  create_staff        :integer
#  car_color           :string(30)
#  low_desire_price    :integer
#  high_desire_price   :integer
#  low_register_year   :integer
#  hight_register_year :integer
#  low_mileage_count   :integer
#  hight_mileage_count :integer
#  gears_type          :string(1)
#  other_desc          :string(500)
#  state               :string(10)
#  arrive_tag          :string(1)
#  arrive_time         :datetime
#  create_time         :datetime
#  update_time         :datetime
#  defeat_time         :datetime
#  invalid_time        :datetime
#  deal_time           :datetime
#  deal_price          :integer
#  deal_vehicle_name   :string(255)
#  sale_kind           :string(1)
#  stock_sub_tag       :string(1)        default("1")
#

require "safe_attributes/base"

module Che3bao
  class SaleIntention < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    include SafeAttributes::Base
    # relationships .............................................................
    has_many :sale_intention_cars, foreign_key: :sale_source_id
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_s_sale_source"
    self.primary_key = "sale_source_id"

    bad_attribute_names :model_name
    # class methods .............................................................
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
