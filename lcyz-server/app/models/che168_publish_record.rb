# == Schema Information
#
# Table name: che168_publish_records # che168发布记录
#
#  id              :integer          not null, primary key # che168发布记录
#  company_id      :integer                                # 公司ID
#  car_id          :integer                                # 发布车辆ID
#  user_id         :integer                                # 发布者ID
#  che168_id       :integer                                # che168对应车辆ID
#  state           :string           default("pending")    # 发布状态
#  error_message   :string                                 # 错误信息
#  command         :text                                   # 发布命令记录
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  publish_state   :string           default("pending")    # che168车辆状态
#  publish_message :string                                 # che168车辆状态信息
#  syncable        :boolean          default(FALSE)        # 是否同步
#  seller_id       :string           default("")           # 销售员ID
#

class Che168PublishRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  belongs_to :car
  belongs_to :user
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :state,
            in: %i(pending processing finished failed)
  enumerize :publish_state,
            in: %i(pending reviewing published failed sold)
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
