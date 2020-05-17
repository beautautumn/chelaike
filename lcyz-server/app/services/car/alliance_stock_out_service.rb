# 联盟出库
# 业务逻辑:
# 复制一辆新车, 并且需要把相关的静态信息(车辆的固有属性)也复制一份
# 包括: 图片(原图, 联盟图, 不包括维保图)
# 过户记录, 维保记录等所有原公司入库之后生成的"动态信息"都不复制
# 入库到新公司, 收购渠道标记为 "联盟入库"
# 生成联盟出库记录, 保存原车 ID 和 新车 ID 等信息, 并将这条设为当前记录
# UPDATED 20160922: 新增 to_shop_id, 用于指定入库分店, 必选. 改掉之前的默认第一分店
class Car < ActiveRecord::Base
  class AllianceStockOutService
    include ErrorCollector

    attr_accessor :alliance_stock_out_inventory, :car, :new_car

    def initialize(user:, car: nil, new_car: nil, params:)
      @user = user
      @car = car
      @new_car = new_car
      @params = params
      # 配合 stock_out_inventories_controller
      if @params["company_id"]
        @params["to_company_id"] = @params["company_id"]
        @params.except! "company_id"
      end
    end

    def create
      fallible @car
      unless @car.may_alliance_stock_out?
        @car.errors.add(:state, "当前车辆状态无法出库")
        return self
      end

      @alliance_stock_out_inventory = @car.alliance_stock_out_inventories.new
      fallible @alliance_stock_out_inventory
      @alliance_stock_out_inventory.assign_attributes(@params)

      begin
        ActiveRecord::Base.connection.transaction do
          # 复制一辆车
          @new_car = @car.deep_clone include: [
            :images,                # 图片
            :alliance_images,       # 联盟图
            :acquisition_transfer   # 收购记录
          ]

          fallible @new_car
          # 处理原车
          update_car
          # 处理新车
          build_new_car
          # 过户记录
          @alliance_stock_out_inventory.to_car_id = @new_car.id
          @alliance_stock_out_inventory.save!

          create_stock_out_record
        end
      rescue ActiveRecord::RecordInvalid
        @alliance_stock_out_inventory
      end

      self
    end

    # 退车
    def update
      fallible @new_car
      unless @new_car.may_alliance_refund?
        @new_car.errors.add(:state, "当前车辆状态无法退车")
        return self
      end

      @alliance_stock_out_inventory = AllianceStockOutInventory
                                      .find_by(to_car_id: @new_car.id, current: true)
      fallible @alliance_stock_out_inventory

      unless @alliance_stock_out_inventory
        @new_car.errors.add(:base, "没有出库记录, 不能退车")
        return self
      end

      @car = @alliance_stock_out_inventory.from_car
      fallible @car
      # 出库记录的退款日期和退款金额
      @alliance_stock_out_inventory.assign_attributes(@params)

      begin
        ActiveRecord::Base.connection.transaction do
          @alliance_stock_out_inventory.save!
          # 新车退库
          @new_car.alliance_refund!
          # 原车回库, 清除成交价格在 car.clear_alliance_stock_out_inventories 完成
          @car.alliance_stock_back!

          create_stock_back_record
        end
      rescue ActiveRecord::RecordInvalid
        @alliance_stock_out_inventory
      end

      self
    end

    private

    def update_car
      # 修改原车状态为联盟出库, 修改成交价格
      @car.closing_cost_wan = @alliance_stock_out_inventory.closing_cost_wan
      @car.seller_id = @alliance_stock_out_inventory.seller_id
      @car.alliance_stock_out!
      @car.save!
    end

    def build_new_car
      # 清空不相关的属性关联
      @new_car.channel_id = nil   # 收购渠道
      @new_car.warranty_id = nil  # 质保等级
      @new_car.state = :in_hall   # 状态改为在厅
      @new_car.state_note = nil   # 清空备注

      # 新车收购价格设置为出库时的成交价
      @new_car.acquisition_price_wan = @alliance_stock_out_inventory.closing_cost_wan

      # 处理新车所属公司、分店，收购人默认为老板
      new_company = Company.find(@alliance_stock_out_inventory.to_company_id)
      new_shop_id = @alliance_stock_out_inventory.to_shop_id

      @new_car.company = new_company
      @new_car.shop_id = new_shop_id

      @new_car.acquirer = new_company.owner

      # 收购记录
      @new_car.acquisition_transfer.user = new_company.owner
      @new_car.acquisition_transfer.user_name = new_company.owner.try(:name)
      @new_car.acquisition_transfer.shop_id = new_shop_id

      # 新车重新生成库存号
      @new_car.stock_number = nil
      # 收购渠道设为"联盟入库", 收购时间
      @new_car.acquisition_type = "alliance"
      @new_car.acquired_at = Time.zone.now
      Car::CreateService.new(
        @new_car.acquirer,
        @new_car,
        @new_car.acquisition_transfer.attributes,
        alliance_stock_in: true).execute
    end

    def create_stock_out_record
      @car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :stock_out,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          new_car_id: @new_car.id,
          alliance_id: @alliance_stock_out_inventory.alliance_id,
          alliance_name: @alliance_stock_out_inventory.alliance.try(:name),
          new_company_name: Company.find(@alliance_stock_out_inventory.to_company_id).try(:name),
          new_shop: Shop.find(@alliance_stock_out_inventory.to_shop_id).try(:name),
          title: "联盟出库",
          name: @car.name,
          stock_number: @car.stock_number,
          user_name: @user.name,
          seller_id: @alliance_stock_out_inventory.seller_id,
          seller_name: User.find(@alliance_stock_out_inventory.seller_id).try(:name),
          stock_out_type: :alliance_stocked_out
        },
        user_passport: @user.passport.to_h
      )
    end

    def create_stock_back_record
      @new_car.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :stock_out,
        shop_id: @new_car.shop_id,
        messages: {
          car_id: @car.id,
          new_car_id: @new_car.id,
          title: "联盟退车",
          name: @new_car.name,
          stock_number: @new_car.stock_number,
          user_name: @user.name,
          new_company_name: Company.find(@car.company_id).try(:name),
          stock_out_type: :alliance_refunded
        },
        user_passport: @user.passport.to_h
      )

      @car.operation_records.create!(
        user: @car.company.owner,
        company_id: @car.company_id,
        operation_record_type: :alliance_stock_back,
        shop_id: @car.shop_id,
        messages: {
          car_id: @car.id,
          title: "联盟退车入库",
          name: @car.name,
          stock_number: @car.stock_number
        },
        user_passport: @car.company.owner.passport.to_h
      )
    end
  end
end
