class CompanyPolicy < ApplicationPolicy
  def index?
    user.can?("联盟管理")
  end

  def customers?
    user.can?("代办客户预定/出库")
  end

  def automated_stock_number?
    user.can?("业务设置")
  end

  def financial_configuration?
    user.can?("财务管理")
  end

  def update_financial_configuration?
    user.can?("财务管理")
  end

  def unified_management?
    automated_stock_number?
  end

  def own_brand_alliances?
    true
  end

  def official_website_url?
    true
  end

  def show?
    true
  end

  def update?
    user.can?("公司信息设置")
  end

  def chat_group?
    master?
  end

  def shops?
    true
  end

  def check_accredited?
    true
  end

  def cities_name?
    true
  end

  private

  def master?
    user.id == record.owner_id
  end
end
