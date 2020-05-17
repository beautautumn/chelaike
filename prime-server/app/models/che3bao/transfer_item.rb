# == Schema Information
#
# Table name: td_b_transfer_item
#
#  item_id             :integer          not null, primary key
#  item_name           :string(40)
#  item_type           :string(1)
#  show_order          :integer
#  valid_tag           :string(1)
#  vehicle_attach_code :string(20)
#

module Che3bao
  class TransferItem < ActiveRecord::Base
    ITEMS = {
      "登记证" => "registration_license",
      "原牌照" => "original_license",
      "原车主身份证原件" => "original_owner_idcard",
      "新车主身份证原件" => "new_owner_idcard",
      "行驶证" => "driving_license",
      "保养手册" => "maintenance_manual",
      "说明书" => "instructions",
      "购置税证" => "purchase_tax",
      "交强险" => "compulsory_insurance"
    }

    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "td_b_transfer_item"
    self.primary_key = "item_id"
    # class methods .............................................................
    def self.items(ids)
      self.where(item_id: ids).pluck(:item_name).inject([]) do |arr, name|
        arr << ITEMS[name]
      end.uniq
    end
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
