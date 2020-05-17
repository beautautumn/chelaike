# == Schema Information
#
# Table name: transfer_records # 过户信息
#
#  id                                :integer          not null, primary key    # 过户信息
#  car_id                            :integer                                   # 车辆ID
#  vin                               :string                                    # 车架号
#  transfer_record_type              :string                                    # 过户类型
#  state                             :string                                    # 状态
#  items                             :text             default([]), is an Array # 手续项目
#  key_count                         :integer                                   # 车钥匙
#  contact_person                    :string                                    # 手续联系人
#  contact_mobile                    :string                                    # 手续联系方式
#  original_location_province        :string                                    # 车辆原属地省份
#  original_location_city            :string                                    # 车辆原属地城市
#  current_location_province         :string                                    # 车辆现属地省份
#  current_location_city             :string                                    # 车辆现属地省份
#  original_plate_number             :string                                    # 原车牌
#  current_plate_number              :string                                    # 现车牌
#  new_plate_number                  :string                                    # 新车牌
#  original_owner                    :string                                    # 原车主
#  original_owner_idcard             :string                                    # 原车主证件号
#  original_owner_contact_mobile     :string                                    # 原车主联系方式
#  transfer_recevier                 :string                                    # 落户人
#  transfer_recevier_idcard          :string                                    # 落户人证件号
#  new_owner                         :string                                    # 新车主
#  new_owner_idcard                  :string                                    # 新车主证件号
#  new_owner_contact_mobile          :string                                    # 新车主联系方式
#  inspection_state                  :string                                    # 验车状态
#  user_id                           :integer                                   # 收购/销售员ID
#  estimated_archived_at             :date                                      # 提档预计完成时间
#  archive_fee_cents                 :integer                                   # 提档费用
#  estimated_transferred_at          :date                                      # 过户预计完成时间
#  transferred_at                    :date                                      # 过户实际完成时间
#  transfer_fee_cents                :integer                                   # 过户费用
#  compulsory_insurance_end_at       :date                                      # 交强险到期日期
#  annual_inspection_end_at          :date                                      # 年审到期日期
#  commercial_insurance_end_at       :date                                      # 商业险到期日
#  commercial_insurance_amount_cents :integer                                   # 商业险金额
#  usage_type                        :string                                    # 使用性质
#  registration_number               :string                                    # 登记证书号
#  transfer_count                    :integer                                   # 过户次数
#  engine_number                     :string                                    # 发动机号
#  allowed_passengers_count          :integer                                   # 核定载客人数
#  note                              :text                                      # 补充说明
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  user_name                         :string                                    # 收购/销售员名字
#  data_completeness                 :jsonb                                     # 资料完整程度
#  shop_id                           :integer                                   # 分店ID
#  total_transfer_fee_cents          :integer                                   # 过户总费用
#  images_count                      :integer          default(0)               # 图片数量
#

class TransferRecord < ActiveRecord::Base
  # 登记证 行驶证 交强险 商业险 原车辆档案 说明书 购置税证 保养手册
  # 原车主身份证件 原车发票 原牌照 新车主身份证原件 临时牌照
  # 二次交易发票 铭牌 环境卡标

  ITEMS = %i(
    registration_license driving_license compulsory_insurance commercial_insurance
    original_vehicle_archive instructions purchase_tax maintenance_manual
    original_owner_idcard original_vehicle_invoice original_license new_owner_idcard
    provisional_license used_vehicle_trade_invoice nameplate environment_mark
  ).freeze

  SHARED_ATTRIBUTES = %i(
    car_id shop_id vin items key_count contact_person contact_mobile
    original_plate_number
    original_owner original_owner_idcard original_owner_contact_mobile
    compulsory_insurance_end_at annual_inspection_end_at
    commercial_insurance_end_at commercial_insurance_amount_cents usage_type
    registration_number transfer_count engine_number allowed_passengers_count
  ).freeze

  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :car, touch: true
  belongs_to :user

  has_many :images, -> { order(:sort).order(:id) }, as: :imageable
  # validations ...............................................................
  # callbacks .................................................................
  before_save :count_data_completeness, :set_user_name
  before_save :syncs_total_transfer_fee_yuan
  before_update :syncs_to_car, if: :acquisition?
  before_update :syncs_to_sale_record, if: :acquisition?
  # scopes ....................................................................
  # additional config .........................................................

  accepts_nested_attributes_for :images, allow_destroy: true

  price_yuan :commercial_insurance_amount, :archive_fee,
             :transfer_fee, :total_transfer_fee

  enumerize :transfer_record_type,
            in: %i(sale acquisition),
            predicates: true

  enumerize :state, in: %i(archiving transfering finished)
  enumerize :inspection_state, in: %i(valid invalid)
  # 非营运 营运 营转非 公户
  enumerize :usage_type, in: %i(personal_use business_use b2p_use rental_use)
  enumerize :items, in: ITEMS, multiple: true

  # class methods .............................................................

  # public instance methods ...................................................
  def shared_attributes
    slice(*TransferRecord::SHARED_ATTRIBUTES).tap do |attributes|
      attributes["original_plate_number"] = current_plate_number
      attributes["original_owner"] = transfer_recevier
      attributes["original_owner_idcard"] = transfer_recevier_idcard
      attributes["original_location_city"] = current_location_city
      attributes["original_location_province"] = current_location_province
    end
  end

  %w(compulsory_insurance commercial_insurance).each do |item|
    define_method item do
      items.include?(item)
    end

    define_method "#{item}=" do |need_item|
      if need_item
        items << item
      else
        items.delete(item)
      end
    end
  end

  def total_transfer_fee_yuan
    price = Util::ExchangeRate.cents_conversion_by(
      total_transfer_fee_cents.to_i, :yuan
    )

    return price if price > 0 # 如果不为空, 说明已经使用新版本

    archive_fee_yuan.to_i + transfer_fee_yuan.to_i
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_user_name
    self.user_name = user.try(:name) if user_id_changed?
  end

  def count_data_completeness
    # 收购过户: 登记证 行驶证 交强险 购置税证 商业险 车辆环保标识 原车身份证件 原车发票
    # 销售过户: 登记证 行驶证 交强险 购置税证 商业险 车辆环保标识 新车身份证件 二次交易发票

    data_columns = %w(registration_license driving_license compulsory_insurance
                      original_owner_idcard)

    total = data_columns.size
    finished = total - (data_columns - items).size

    self.data_completeness = { finished: finished, total: total }
  end

  def syncs_total_transfer_fee_yuan
    stock_out_inventory = car.stock_out_inventory
    return if stock_out_inventory.blank?

    stock_out_inventory.update_columns(
      total_transfer_fee_cents: total_transfer_fee_cents
    )
  end

  def syncs_to_car
    return unless vin_changed?

    car.update!(vin: vin)
  end

  def syncs_to_sale_record
    car = Car.with_deleted.find_by(id: car_id)

    car.build_sale_transfer.save if car.sale_transfer.blank?
    car.sale_transfer.reload.update!(shared_attributes)

    car.update_columns(current_plate_number: current_plate_number)
  end
end
