# == Schema Information
#
# Table name: easy_loan_debits # 借款方统计信息
#
#  id                    :integer          not null, primary key # 借款方统计信息
#  inventory_amount      :integer                                # 计算月库存资金量
#  operating_health      :decimal(, )                            # 计算月经营健康评级
#  industry_rating       :decimal(, )      default(3.0)          # 设置借方行业风评
#  assets_debts_rating   :decimal(, )      default(0.6)          # 设置借方资产负债率
#  comprehensive_rating  :decimal(, )                            # 计算月综合评级
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :integer                                # 统计数据和公司关联
#  beat_global           :decimal(, )                            # 综合评分打败全国车商数据
#  beat_local            :decimal(, )                            # 综合评分打败本地车商数据
#  real_inventory_amount :integer                                # 真实库存资金量数据
#  cash_turnover_rate    :decimal(, )                            # 资金周转率
#  car_gross_profit_rate :decimal(, )                            # 月利润率
#

class EasyLoan::Debit < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  has_many :operation_records, -> { order("id desc") },
           as: :targetable,
           class_name: "::OperationRecord"
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :with_year_and_month, -> (year, month) {
    debits_by_date(year, month)
  }

  scope :with_date_and_company, -> (company_id, year, month) {
    debits_by_date(year, month).where(company_id: company_id)
  }
  # additional config .........................................................
  # class methods .............................................................
  class << self
    def debits_by_date(year, month)
      date = DateTime.new(year, month)
      where(created_at: date..date.next_month)
    end
  end
  # public instance methods ...................................................

  def beat_local_percentage
    self.beat_local.present? ? (self.beat_local * 100).to_f.round(0) : nil
  end

  def beat_country_percentage
    self.beat_global.present? ? (self.beat_global * 100).to_f.round(0) : nil
  end

  def rating_statements_text
    {
      comprehensive_rating: comprehensive_rating_text,
      operating_health: operating_health_text,
      industry_rating: industry_rating_text
    }
  end

  def shop_id
    company.shops.first.id
  end

  %w(comprehensive_rating operating_health industry_rating).each do |attr|
    define_method "#{attr}_text" do
      self[attr] ||= 0

      score = calculate_score(attr)
      EasyLoan::RatingStatement.where(
        score: score,
        rate_type: attr
      ).first.try(:content) || ""
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def calculate_score(attr)
    original_score = self[attr]
    if original_score.to_i == original_score
      original_score
    else
      original_score.truncate + 1
    end
  end
end
