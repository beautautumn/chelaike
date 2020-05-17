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

module CarPriceHistorySerializer
  class Common < ActiveModel::Serializer
    attributes :car_id, :user_id, :user_name, :previous_show_price_wan,
               :show_price_wan, :previous_online_price_wan, :online_price_wan,
               :previous_sales_minimun_price_wan, :sales_minimun_price_wan,
               :previous_manager_price_wan, :manager_price_wan,
               :previous_alliance_minimun_price_wan, :red_stock_warning_days,
               :alliance_minimun_price_wan, :yellow_stock_warning_days, :note,
               :created_at, :new_car_guide_price_wan, :new_car_additional_price_wan,
               :new_car_discount, :new_car_final_price_wan

    def new_car_guide_price_wan
      object.car.new_car_guide_price_wan
    end

    def new_car_additional_price_wan
      object.car.new_car_additional_price_wan
    end

    def new_car_discount
      object.car.new_car_discount
    end

    def new_car_final_price_wan
      object.car.new_car_final_price_wan
    end
  end
end
