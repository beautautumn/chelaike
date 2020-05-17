class StatisticPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  private

  def cash_flow?
    shop_id = record.shop_id.try(:to_i)

    user.can?("库存统计查看") && (
      shop_id.blank? || user.shop_id == shop_id || cross_shop_read_statistic?
    )
  end

  def unified_management?
    user.company.unified_management
  end

  def cross_shop_read_statistic?
    user.cross_shop_read_statistic || unified_management?
  end
end
