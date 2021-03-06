# == Schema Information
#
# Table name: car_alliance_blacklists # 不允许车辆在某个平台展示
#
#  id          :integer          not null, primary key # 不允许车辆在某个平台展示
#  car_id      :integer
#  alliance_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CarAllianceBlacklist < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  belongs_to :alliance
  # validations ...............................................................
  validates :car_id, presence: true,
                     uniqueness: { scope: :alliance_id }
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
