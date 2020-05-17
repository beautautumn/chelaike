# == Schema Information
#
# Table name: car_state_histories # 车辆状态修改历史
#
#  id                     :integer          not null, primary key # 车辆状态修改历史
#  car_id                 :integer                                # 车辆ID
#  previous_state         :string                                 # 上一个状态
#  state                  :string                                 # 当前状况
#  sellable               :boolean                                # 是否可售
#  occurred_at            :datetime                               # 修改时间
#  note                   :text                                   # 描述
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  predicted_restocked_at :datetime                               # 预计回厅时间
#

class CarStateHistory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :car
  # validations ...............................................................
  validates :occurred_at, presence: true
  validate :occurred_at_must_be_available
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def state_changed_at
    if occurred_at
      now = Time.zone.now
      occurred_at + now.hour.hours + now.min.minutes
    else
      Time.zone.now
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def occurred_at_must_be_available
    histories = self.class.where(car_id: car_id)

    if !histories.empty?
      last_occurred_at = histories.last.occurred_at

      if occurred_at.to_date < last_occurred_at.to_date
        errors.add(:occurred_at, "发生时间必须大于等于上一次发生时间(#{last_occurred_at})")
      end
    else
      return errors.add(:occurred_at, "请先填写车辆收购日期") unless car.acquired_at.present?

      if occurred_at.to_date < car.acquired_at.to_date
        errors.add(:occurred_at, "发生时间必须大于等于收购日期(#{car.acquired_at.to_date})")
      end
    end
  end
end
