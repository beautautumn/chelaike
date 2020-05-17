module AuthorityHelper
  def stock_age_days?
    authority_filter("车辆库龄查看")
  end

  def acquisition_price_wan?
    object.acquirer_id == scope.id || authority_filter("收购价格查看")
  end

  def acquisition_info?
    object.acquirer_id == scope.id || authority_filter("收购信息查看")
  end

  def alliance_minimun_price_wan?
    authority_filter("联盟底价查看")
  end

  def sales_minimun_price_wan?
    authority_filter("销售底价查看")
  end

  def manager_price_wan?
    authority_filter("经理底价查看")
  end

  def amount_yuan?
    authority_filter("整备费用查看")
  end
end
