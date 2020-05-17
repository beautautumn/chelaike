# == Schema Information
#
# Table name: tf_s_salesource_intend
#
#  intend_id      :integer          not null, primary key
#  sale_source_id :integer
#  brand_code     :integer
#  factory_code   :integer
#  series_code    :integer
#  model_code     :integer
#  model_name     :string(255)
#  catalogue_name :string(255)
#  brand_name     :string(64)
#  series_name    :string(64)
#

require "safe_attributes/base"

module Che3bao
  class SaleIntentionCar < ActiveRecord::Base
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
    self.table_name = "tf_s_salesource_intend"
    self.primary_key = "intend_id"

    bad_attribute_names :model_name
    # class methods .............................................................
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
