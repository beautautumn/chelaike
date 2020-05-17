# == Schema Information
#
# Table name: intention_push_histories # 意向跟进历史
#
#  id                    :integer          not null, primary key # 意向跟进历史
#  intention_id          :integer                                # 意向ID
#  state                 :string                                 # 跟进状态/结果
#  checked               :boolean          default(FALSE)        # 是否到店/是否评估实车
#  note                  :text                                   # 说明
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  estimated_price_cents :integer                                # 评估车价
#  interviewed_time      :datetime                               # 预约时间
#  processing_time       :datetime                               # 跟进时间
#  intention_level_id    :integer                                # 意向等级ID
#  checked_count         :integer                                # 到店/评估次数
#  executor_id           :integer                                # 执行人
#  deposit_cents         :integer                                # 定金
#  closing_cost_cents    :integer                                # 成交价格
#  closing_car_id        :integer                                # 成交车辆ID
#  closing_car_name      :string                                 # 成交车辆名称
#  type                  :string                                 # STI
#

class IntentionPushHistory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :intention_level
  belongs_to :executor, class_name: "User", foreign_key: :executor_id
  belongs_to :closing_car, class_name: "Car", foreign_key: :closing_car_id

  has_many :intention_push_cars
  has_many :cars, through: :intention_push_cars, source: :car
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :state, in: %i(
    pending processing interviewed reserved cancel_reserved
    completed acquired hall_consignment online_consignment failed invalid
  )

  price_wan :estimated_price, :deposit, :closing_cost
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
