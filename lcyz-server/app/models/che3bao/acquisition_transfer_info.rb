# == Schema Information
#
# Table name: tf_t_transfer_info
#
#  transfer_id           :integer          not null, primary key
#  buy_staff             :integer
#  oper_staff            :integer
#  sell_staff            :integer
#  transfer_item         :string(255)
#  owner_name            :string(40)
#  contact_tel           :string(40)
#  transfer_fee          :integer
#  pre_finish_date       :date
#  comm_issur_valid_date :string(10)
#  issur_valid_date      :string(10)
#  check_valid_month     :string(10)
#  other_desc            :string(255)
#  transfer_type         :string(1)
#  create_time           :datetime
#  update_time           :datetime
#  comm_issur_fee        :integer
#

module Che3bao
  class AcquisitionTransferInfo < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    has_one :stock, class_name: Stock.name, foreign_key: :buy_transfer_id

    belongs_to :buy_staff_user, foreign_key: :buy_staff, class_name: Staff.name
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_t_transfer_info"
    self.primary_key = "transfer_id"
    # class methods .............................................................
    # public instance methods ...................................................
    def items
      TransferItem.items(transfer_item.split(",")) if transfer_item.present?
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
