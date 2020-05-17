class CarPolicy < ApplicationPolicy
  def index?
    User::Pundit.authorities = ["在库车辆查询"]
  end

  def out_of_stock?
    User::Pundit.authorities = ["已出库车辆查询"]
  end

  def create?
    User::Pundit.can_can?(user, record, ["车辆新增入库"])
  end

  def edit?
    update?
  end

  def show?
    true
  end

  def multi_images_share?
    show?
  end

  def shared_url?
    show?
  end

  def shared_car_list?
    true
  end

  def check_vin?
    true
  end

  def update?
    authority = if record.in_state_in_stock?
                  "车辆信息编辑"
                else
                  "出库车辆编辑"
                end

    case user
    when AllianceCompany::User
      user.can?(authority)
    when User
      User::Pundit.can_can?(user, record, [authority])
    end
  end

  def onsale?
    authority = "车辆销售定价"

    User::Pundit.can_can?(user, record, [authority])
  end

  def info_by_vin?
    true
  end

  def images_download?
    true
  end

  def import_status?
    true
  end

  def images_update?
    User::Pundit.can_can?(user, record, ["车辆图片上传"])
  end

  def import?
    user.can?("网站车辆导入")
  end

  def import_search?
    import?
  end

  def destroy?
    User::Pundit.can_can?(user, record, ["在库车辆删除"])
  end

  def brands?
    true
  end

  def acquirers?
    true
  end

  def sellers?
    true
  end

  def series?
    true
  end

  def alliances?
    true
  end

  def update_alliances?
    true
  end

  def alliance_similar?
    true
  end

  def similar?
    true
  end

  def viewed?
    true
  end

  def meta_info?
    true
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      case
      when !User::Pundit.can?(user)
        @scope = scope.where.not(shop_id: user.shop_id)
      when !User::Pundit.cross_shop_can?(user)
        @scope = scope.where(shop_id: user.shop_id)
      else
        @scope
      end
    end
  end
end
