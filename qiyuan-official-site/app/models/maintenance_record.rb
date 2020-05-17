# frozen_string_literal: true

# == Schema Information
#
# Table name: maintenance_records # 维保记录
#
#  id                  :integer          not null, primary key
#  vin                 :string                                 # 车架号
#  car_name            :string                                 # 车辆名
#  last_date           :string                                 # 最后入店日期
#  mileage             :string                                 # 里程
#  new_car_warranty    :string                                 # 新车质保
#  emission_standard   :string                                 # 排放标准
#  total_records_count :integer                                # 记录条数
#  record_abstract     :jsonb                                  # 记录摘要
#  record_detail       :jsonb                                  # 记录详情
#  car_id              :integer                                # 关联 car id
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class MaintenanceRecord < ApplicationRecord
  store_accessor :record_abstract,
                 :summary,
                 :last_record_mileage,
                 :last_record_date,
                 :ab, :en, :mi, :sd, :tr, :fire, :water

  serialize :record_detail, Array

  alias_attribute :abstract_items, :record_abstract
  has_many :orders, as: :orderable

  # 概要, 记录条数, 最后里程, 最后日期
  # 安全气囊, 发动机, 里程表, 结构部件, 变速箱, 火烧, 水泡
  RecordAbstract = Struct.new(
    :summary,
    :last_record_mileage, :last_record_date,
    :ab, :en, :mi, :sd, :tr, :fire, :water
  )

  RecordDetail = Struct.new(
    :date, :category, :item, :material, :mileage
  )

  def record_abstract
    original_hash = self[:record_abstract]
    return {} if original_hash.blank?
    RecordAbstract.new(
      original_hash["summary"],
      original_hash["last_record_mileage"],
      original_hash["last_record_date"],
      original_hash["ab"],
      original_hash["en"],
      original_hash["mi"],
      original_hash["sd"],
      original_hash["tr"],
      original_hash["fire"],
      original_hash["water"]
    )
  end

  def items
    [].tap do |items|
      record_detail.each do |record|
        items << RecordDetail.new(
          record["date"],
          record["category"],
          record["item"],
          record["material"],
          record["mileage"]
        )
      end
    end
  end
end
