module CarSerializer
  class Che300List < ActiveModel::Serializer
    attributes :car_id, # 车辆 id
               # :operation,                     # 操作说明
               :vin, :brand, :series, :model, # vin码, 品牌, 车系, 车型
               # :model_year,                    # 车型年款
               :car_level,                       # 车辆级别(微型车/小型车...)
               :province, :city,                 # 省份, 城市
               :liter, :emission_standard,       # 排量, 排放标准
               :gear_type, :price, :mileage,     # 变速箱, 售价(万元), 里程(万公里)
               :register_date,                   # 首次上牌时间
               :insurance_date,                  # 保险到期日
               :audit_date,                      # 年检到期日
               :post_time,                       # 发布时间
               :status, :color,                  # 状态(在售/已售/下架), 颜色
               #  :trade_address,                # 交易地点
               :transfer_times, # 过户次数
               #  :contactor, :phone,            # 联系人, 电话
               #  :car_url, :pictures,           # 车辆网站 URL, 图片 URL
               #  :inspection_report_url,        # 检测报告
               #  :inspect_status,               # 是否检测
               #  :inspector_description,        # 评估师描述,
               :car_description # 车辆描述

    def car_id
      object.id
    end

    def brand
      object.brand_name
    end

    def series
      object.series_name
    end

    def model
      object.style_name
    end

    def province
      object.try(:acquisition_transfer).try(:current_location_province)
    end

    def city
      object.try(:acquisition_transfer).try(:current_location_city)
    end

    def liter
      object.displacement
    end

    def gear_type
      object.transmission_text
    end

    def price
      object.show_price_wan
    end

    def register_date
      object.licensed_at
    end

    def insurance_date
      object.try(:acquisition_transfer).try(:compulsory_insurance_end_at)
    end

    def audit_date
      object.try(:acquisition_transfer).try(:annual_inspection_end_at)
    end

    def post_time
      object.created_at
    end

    def status
      object.state_text
    end

    def color
      object.exterior_color
    end

    def car_description
      object.selling_point
    end

    def transfer_times
      object.try(:acquisition_transfer).try(:transfer_count)
    end

    def car_level
      object.car_type_text
    end
  end
end
