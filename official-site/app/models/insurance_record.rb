# frozen_string_literal: true
# == Schema Information
#
# Table name: insurance_records # 保险理赔记录
#
#  id                    :integer          not null, primary key
#  vin                   :string                                 # vin码
#  mileage               :string                                 # 里程数
#  total_records_count   :integer                                # 总记录数
#  claims_count          :integer                                # 事故次数
#  record_abstract       :jsonb                                  # 记录摘要
#  claims_abstract       :jsonb                                  # 出险事故摘要
#  claims_total_fee_yuan :decimal(12, 2)   default(0.0)          # 事故总损失元
#  claims_details        :jsonb                                  # 事故详细记录
#  car_id                :integer                                # 报告对应的car_id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  make                  :string                                 # 车型信息
#  order_id              :string                                 # 查询报告ID
#  engine_num            :string                                 # 发动机号
#  license_no            :string                                 # 车牌号
#

class InsuranceRecord < ApplicationRecord
  has_many :orders, as: :orderable
  # 最新记录时间, 车辆性质, 生产年份, 里程表记录, 排放标准
  RecordAbstract = Struct.new(
    :latest_record_time, :used_type,
    :made_year, :mileage_record, :emission_standard
  )
  # 记录日期，记录公里数，事故损失(元)，记录类型，事故类型，事故经过，维修内容，更换配件
  ClaimDetail = Struct.new(
    :claim_date,
    :claim_mileage, # 记录公里数
    :lobor_fee, # 事故损失(元)
    :detail_type, # 记录类型
    :accident_type, # 事故类型
    :description, # 事故经过
    :repair_detail, # 维修内容
    :material # 更换配件
  )

  class << self
    def initialize_with_result(car_id, res_data)
      claims_abstract = calculate_claims_abstract(res_data)
      new(
        vin: res_data.fetch(:vin),
        total_records_count: res_data.fetch(:insurance).size,
        claims_count: res_data.fetch(:claims).size,
        record_abstract: RecordAbstract.new(
          latest_claim_date(res_data),
          "", "", "", ""
        ),
        claims_abstract: claims_abstract,
        claims_total_fee_yuan: claims_abstract.fetch(:total_lose_amount),
        claims_details: res_data.fetch(:claims),
        car_id: car_id,
        make: res_data.fetch(:make),
        order_id: res_data.fetch(:order_id),
        engine_num: res_data.fetch(:engine_num),
        license_no: res_data.fetch(:license_no)
      )
    end

    private

    def latest_claim_date(res_data)
      claims = res_data.fetch(:claims)
      claim_dates = claims.map { |claim| claim.fetch(:ClaimDate) }
      claim_dates.sort.last
    end

    def calculate_claims_abstract(res_data)
      insurances = res_data.fetch(:insurance)
      claims = res_data.fetch(:claims)
      claim_dates = claims.map { |claim| claim.fetch(:ClaimDate) }

      periods = insurances.inject([]) do |acc, insurance_period|
        start_date = insurance_period.fetch(:StartDate)
        end_date = insurance_period.fetch(:EndDate)

        acc << {
          start_date: start_date,
          end_date: end_date,
          claims_count: claim_dates.select { |date| date.between?(start_date, end_date) }.size
        }
      end

      total_fees = claims.inject(0) do |sum, claim|
        sum + claim.fetch(:TotalFee)
      end

      { periods: periods, total_lose_amount: total_fees }
    end
  end

  # 最近一次理赔
  def latest_record
    { date: record_abstract["latest_record_time"] }
  end

  # 最大金额理赔
  def max_amount_record
    if self.claims_details.present?
      max_record = claims_details.sort_by { |detail| detail.fetch("lobor_fee").to_f }.last
      {
        date: max_record.fetch("claim_date"),
        amount_yuan: max_record.fetch("lobor_fee")
      }
    else
      nil
    end
  end

  def records_count
    claims_details.try(:size)
  end

  def record_abstract
    original_hash = self[:record_abstract]
    return {} if original_hash.blank?
    RecordAbstract.new(
      original_hash["latest_record_time"],
      original_hash["used_type"],
      original_hash["made_year"],
      original_hash["mileage_record"],
      original_hash["emission_standard"]
    )
  end
end
