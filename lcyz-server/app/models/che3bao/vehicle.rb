# == Schema Information
#
# Table name: tf_t_vehicle
#
#  vehicle_id            :integer          not null, primary key
#  car_brand             :integer
#  car_factory           :integer
#  car_series            :integer
#  car_model             :integer
#  car_type              :integer                                # 0——轿车，1——跑车，2——???野??，3——商务车
#  shelf_code            :string(20)
#  shelf_code_locate     :string(40)
#  motor_code            :string(20)
#  motor_code_locate     :string(40)
#  certification_code    :string(20)
#  old_color             :string(32)
#  car_color             :string(32)
#  color_chg_tag         :string(1)                              # 0-没有变更；1-变更
#  upholstery_color      :string(32)
#  output_volume         :string(20)
#  turbo_charger         :string(1)                              # 0-???;1-是
            
#  fuel_type             :string(1)                              # 0-汽油；1-柴油；2-电动；3-混合动力；9-其他；
#  gears_type_tag        :string(1)                              # 0——手动；1——??自一体；2—其他
#  motor_type            :string(1)
#  driver_kind           :string(1)                              # 0——前驱；1——后驱；2——四驱
#  factory_month         :string(10)
#  mileage_count         :integer
#  maintain_mileage      :integer
#  mileage_unit          :string(1)        default("0")          # 0：公里1：英里
#  environmental_level   :string(1)                              # 0--国1；1--国2；2--国3；3--国4；4--国5；
#  obd_tag               :string(1)                              # 0——否；1——是
#  passenger_num         :integer
#  car_door_num          :integer
#  standard_equip        :string(2000)
#  cust_equip            :string(2000)
#  regist_month          :string(32)
#  register_num          :string(50)
#  maint_tag             :string(1)                              # 0-无；1-有
#  maint_desc            :string(255)
#  warranty_tag          :string(1)                              # 1：厂家质???2：商家延保0：无
#  used_type             :string(1)                              # 0-非营运；1-营运;2-营转非；3-租赁
#  used_kind             :integer                                # 0——私户；1——公户
#  transfer_tag          :integer                                # 0表示没有过过户
#  jqx_insurance_code    :integer
#  issur_valid_tag       :string(1)                              # 0——无?????1?????—???
#  issur_valid_date      :string(10)                             # 格??：YYYYMM  --变更保存日期 用字符串保存
#  jqx_insurance_num     :string(40)
#  insurance_code        :integer
#  comm_issur_valid_tag  :string(1)                              # 0-无；1-有
#  comm_issur_valid_date :string(10)                             # 格???：YYYYMM  --变更保存日期 用字符串保存
#  comm_issur_fee        :integer
#  insurance_num         :string(40)
#  check_valid_month     :string(10)                             # 格式??YYYYMM
#  other_mis_material    :string(255)
#  other_attachment      :string(255)
#  remodel_tag           :string(1)
#  old_licensecode       :string(80)                             # 收购之前????????主车??
#  license_code          :string(20)                             # 收购之后，销??之????的车牌
#  new_licensecode       :string(20)                             # 销??之后的新车主车牌
#  create_time           :datetime
#  update_time           :datetime
#  model_name            :string(255)
#  catalogue_name        :string(255)
#  series_name           :string(255)
#  brand_name            :string(64)
#  old_catalogue_tag     :string(1)        default("0")
#  cond_desc             :string(2000)
#  old_owner             :string(500)
#  new_owner             :string(500)
#  settle_person         :string(500)
#  first_list_pic        :string(255)
#  pic_count             :integer
#  first_pic_id          :integer
#  actual_mileage        :integer
#

require "safe_attributes/base"

module Che3bao
  class Vehicle < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    include SafeAttributes::Base
    has_one :stock
    has_many :vehicle_images
    has_many :acquisition_transfer_images
    has_many :vehicle_attach_relationships
    has_many :vehicle_attachs,
             through: :vehicle_attach_relationships,
             source: :vehicle_attach
    # relationships .............................................................
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    bad_attribute_names :model_name

    self.table_name = "tf_t_vehicle"
    self.primary_key = "vehicle_id"
    # class methods .............................................................
    def self.execute_image(image)
      return unless image.present?
      image.gsub("kimg.nayouche.com", "image.che3bao.com")
    end
    # public instance methods ...................................................
    def emission_standard
      if environmental_level.present? && (0..4).include?(environmental_level.to_i)
        "guo_#{environmental_level.to_i + 1}"
      end
    end

    def vehicle_images_attributes
      location = {
        1  => "右前45度",
        2  => "正面",
        3  => "左前45度",
        4  => "侧面",
        5  => "左后45度",
        6  => "后面",
        7  => "右后45度",
        10 => "发动机舱",
        11 => "前排座椅-左前门",
        13 => "里程表",
        15 => "后排座椅-左前门",
        16 => "仪表台",
        17 => "前排座椅-右前门",
        18 => "轮毂",
        20 => "后备箱",
        21 => "后排座椅-右前门",
        22 => "天窗",
        23 => "其他"
      }

      vehicle_images.map do |vehicle_image|
        {
          url: self.class.execute_image(vehicle_image.pic_addr),
          location: location[vehicle_image.pic_kind.to_i],
          is_cover: vehicle_image.show_tag.to_i == 1
        }
      end
    end

    def acquisition_transfer_images_attributes
      location = {
        1 => "行驶证",
        2 => "登记证",
        3 => "车辆牌照",
        5 => "原始发票",
        6 => "购置税",
        19 => "原车主身份证",
        21 => "买主身份证",
        23 => "铭牌",
        24 => "其他资料"
      }

      acquisition_transfer_images.map do |image|
        {
          url: self.class.execute_image(image.pic_addr),
          location: location[image.pic_kind.to_i],
          is_cover: image.show_tag.to_i == 1
        }
      end.reverse
    end

    def fuel_type
      fuel_types = {
        0 => "gasoline", # 汽油
        1 => "diesel",   # 柴油
        2 => "electric", # 电动
        3 => "hybrid",   # 混合动力
        9 => "other"     # 其他"
      }

      fuel_types[self[:fuel_type].to_i] if self[:fuel_type].present?
    end

    def transmission
      transmissions = {
        0 => "manual",           # 手动
        1 => "auto",             # 自动
        2 => "manual_automatic", # 手自一体
        3 => "other"             # 其他
      }

      transmissions[gears_type_tag.to_i] if gears_type_tag.present?
    end

    def new_car_warranty
      new_car_warranties = {
        1 => "manufacturer", # 厂商
        2 => "seller",       # 商家
        0 => "none"          # 无
      }

      warranty_tag.present? ? new_car_warranties[warranty_tag.to_i] : nil
    end

    def car_key
      vehicle_attach_relationships.find_by(attach_id: 7).try(:value)
    end

    def turbo_charger?
      turbo_charger.present? ? turbo_charger.to_i == 1 : nil
    end

    def licensed_at
      regist_month.present? ? "#{regist_month}-01" : nil
    end

    def manufactured_at
      Util::Date.parse_date_string(factory_month)
    end

    def compulsory_insurance_end_at
      Util::Date.parse_date_string(issur_valid_date)
    end

    def annual_inspection_end_at
      Util::Date.parse_date_string(check_valid_month)
    end

    def commercial_insurance_end_at
      Util::Date.parse_date_string(comm_issur_valid_date)
    end

    def maintain_history?
      maint_tag.present? ? maint_tag.to_i == 1 : nil
    end

    def style_name
      if read_attribute(:model_name).present?
        read_attribute(:model_name)
      else
        "未填写"
      end
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
