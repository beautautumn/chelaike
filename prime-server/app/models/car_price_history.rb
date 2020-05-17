# == Schema Information
#
# Table name: car_price_histories
#
#  id                                    :integer          not null, primary key
#  car_id                                :integer                                # 车辆ID
#  user_id                               :integer                                # 调价人ID
#  user_name                             :string                                 # 调价人
#  previous_show_price_cents             :integer                                # 旧展厅价格
#  show_price_cents                      :integer                                # 展厅价格
#  previous_online_price_cents           :integer                                # 旧网络价格
#  online_price_cents                    :integer                                # 网络价格
#  previous_sales_minimun_price_cents    :integer                                # 旧销售底价
#  sales_minimun_price_cents             :integer                                # 新销售底价
#  previous_manager_price_cents          :integer                                # 旧经理底价
#  manager_price_cents                   :integer                                # 新经理底价
#  previous_alliance_minimun_price_cents :integer                                # 旧联盟底价
#  alliance_minimun_price_cents          :integer                                # 新联盟底价
#  yellow_stock_warning_days             :integer          default(30)           # 库存预警时间
#  note                                  :text                                   # 说明
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  red_stock_warning_days                :integer          default(45)           # 红色预警
#

class CarPriceHistory < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car
  belongs_to :user
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :show_price, :online_price, :sales_minimun_price,
            :manager_price, :alliance_minimun_price,
            :previous_show_price, :previous_online_price,
            :previous_sales_minimun_price, :previous_manager_price,
            :previous_alliance_minimun_price

  accepts_nested_attributes_for :car
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
