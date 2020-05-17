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
#

module TransferRecordSerializer
  class OpenAcquisition < ActiveModel::Serializer
    attributes :id, :car_id, :annual_inspection_end_at,
               :original_location_province, :original_location_city,
               :current_plate_number
  end
end
