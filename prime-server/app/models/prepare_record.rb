# == Schema Information
#
# Table name: prepare_records # 整备管理记录
#
#  id                     :integer          not null, primary key # 整备管理记录
#  car_id                 :integer                                # 车辆ID
#  state                  :string                                 # 整备状态
#  total_amount_cents     :integer                                # 费用合计
#  start_at               :date                                   # 开始时间
#  end_at                 :date                                   # 结束时间
#  repair_state           :string                                 # 维修现状
#  note                   :text                                   # 补充说明
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  preparer_id            :integer                                # 整备员ID
#  shop_id                :integer                                # 分店ID
#  estimated_completed_at :date                                   # 预计完成时间
#

class PrepareRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :preparer, class_name: "User", foreign_key: :preparer_id
  belongs_to :car, touch: true
  has_many :prepare_items
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  accepts_nested_attributes_for :prepare_items, allow_destroy: true

  price_yuan :total_amount

  enumerize :state, in: %i(preparing progress finished)
  enumerize :repair_state, in: %i(first_time second_time)
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
