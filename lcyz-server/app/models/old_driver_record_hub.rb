# == Schema Information
#
# Table name: old_driver_record_hubs # 老司机报告内容
#
#  id          :integer          not null, primary key # 老司机报告内容
#  vin         :string                                 # vin码
#  order_id    :string                                 # 对方订单ID
#  engine_num  :string                                 # 发动机号
#  license_no  :string                                 # 车牌号
#  id_numbers  :string                                 # 身份证号，以逗号分隔
#  sent_at     :datetime                               # 发送时间
#  notify_at   :datetime                               # 回调通知时间
#  make        :string                                 # 车型信息
#  insurance   :jsonb                                  # 保险区间
#  claims      :jsonb                                  # 事故
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  meter_error :boolean                                # 里程表是否异常
#  smoke_level :string                                 # 排放标准
#  year        :string                                 # 生产年份
#  nature      :string                                 # 车辆性质
#

class OldDriverRecordHub < ActiveRecord::Base
  # accessors .................................................................

  RecordAbstract = Struct.new(
    :latest_record_time, :used_type,
    :made_year, :mileage_record, :emission_standard
  )
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  has_many :old_driver_records
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................

  # 总记录数
  def total_records_count
    claims.try(:size)
  end

  # 事故次数
  def claims_count
    return 0 if claims.blank?
    claims.count { |claim| !claim.fetch("Type").in?(%w(保养 首保)) }
  end

  def max_mileage
    return 0 unless claims
    claims.map { |claim| claim.fetch("Mileage", 0) }.max
  end

  # 报告摘要
  def record_abstract
    meter_error_str = meter_error ? "异常" : "正常"
    RecordAbstract.new(
      latest_claim_date,
      nature, year, meter_error_str, smoke_level
    )
  end

  # 出险事故摘要
  def claims_abstract
    calculate_claims_abstract
  end

  # 最近一条记录时间
  def latest_claim_date
    return unless claims
    claim_dates = claims.map { |claim| claim.fetch("ClaimDate") }
    claim_dates.sort.last
  end

  # 事故总费用
  def claims_total_fee_yuan
    calculate_claims_abstract.fetch(:total_lose_amount)
  end

  def generated_date
    return "" unless notify_at.present?
    notify_at.strftime("%Y-%m-%d")
  end

  private

  def calculate_claims_abstract
    return { periods: [], total_lose_amount: 0 } unless claims
    return @_claims_abstract if @_claims_abstract.present?
    insurances = insurance || []

    periods = insurances.inject([]) do |acc, insurance_period|
      start_date = insurance_period.fetch("StartDate")
      end_date = insurance_period.fetch("EndDate")

      acc << {
        start_date: start_date,
        end_date: end_date,
        claims_count: claims.count { |claim| claim.fetch("ClaimDate").between?(start_date, end_date) && claim.fetch("Type") == "保险" }
      }
    end

    total_fees = claims.inject(0) do |sum, claim|
      sum + claim.fetch("TotalFee")
    end

    @_claims_abstract = { periods: periods, total_lose_amount: total_fees }
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
