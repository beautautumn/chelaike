# == Schema Information
#
# Table name: tf_b_acqu_source
#
#  acqu_source_id    :integer          not null, primary key
#  region_code       :integer
#  region_name       :string(64)
#  brand_code        :integer
#  brand_name        :string(64)
#  factory_code      :integer
#  series_code       :integer
#  series_name       :string(64)
#  model_code        :integer
#  model_name        :string(128)
#  catalogue_name    :string(255)
#  cust_id           :integer
#  owner_staff       :integer
#  owner_corp        :integer
#  stock_id          :integer
#  create_staff      :integer
#  car_color         :string(32)
#  mileage_count     :integer
#  gears_type        :string(1)
#  output_volume     :string(10)
#  turbo_charger     :string(1)
#  regist_month      :string(10)
#  intend_price      :integer
#  state             :string(10)
#  eval_tag          :string(1)
#  eval_time         :datetime
#  other_desc        :string(500)
#  create_time       :datetime         not null
#  update_time       :datetime         not null
#  defeat_time       :datetime
#  invalid_time      :datetime
#  deal_time         :datetime
#  deal_price        :integer
#  deal_vehicle_name :string(255)
#  cust_sub_tag      :string(1)
#

require "safe_attributes/base"

module Che3bao
  class AcquisitionIntention < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    include SafeAttributes::Base
    # relationships .............................................................
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_b_acqu_source"
    self.primary_key = "acqu_source_id"
    # class methods .............................................................
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
