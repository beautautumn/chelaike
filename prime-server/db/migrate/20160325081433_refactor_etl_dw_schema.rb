class RefactorEtlDwSchema < ActiveRecord::Migration
  def change
    drop_table :dw_company_dimensions
    drop_table :dw_acquisition_info_dimensions
    drop_table :dw_out_stock_info_dimensions

    create_table :dw_shop_dimensions, comment: "分店纬度" do |t|
      t.integer :shop_id, index: true, comment: "分店ID"
      t.integer :company_id, index: true, comment: "公司ID"
      t.string :name, comment: "分店名称"
      t.datetime :deleted_at, comment: "删除时间"
    end

    create_table :dw_acquired_at_dimensions, comment: "收购时间纬度" do |t|
      t.datetime :acquired_at, index: true, comment: "收购时间"
      t.date :acquired_at_date, index: true, comment: "收购日期"
      t.integer :acquired_at_year, index: true, comment: "收购日期(年)"
      t.integer :acquired_at_month, index: true, comment: "收购日期(月)"
    end

    create_table :dw_stock_out_at_dimensions, comment: "出库时间纬度" do |t|
      t.date :stock_out_at, index: true, comment: "收购时间"
      t.integer :stock_out_at_year, index: true, comment: "收购日期(年)"
      t.integer :stock_out_at_month, index: true, comment: "收购日期(月)"
    end

    add_column :dw_acquisition_facts, :acquisition_price_cents, :bigint, default: 0, comment: "收购价格"
    add_column :dw_acquisition_facts, :acquirer_id, :integer, index: true, comment: "收购员"
    add_column :dw_acquisition_facts, :acquisition_type, :string, index: true, comment: "收购类型"
    add_column :dw_acquisition_facts, :acquired_at_dimension_id, :integer, index: true, comment: "收购日期纬度"

    remove_column :dw_acquisition_facts, :acquisition_info_dimension_id
    remove_column :dw_acquisition_facts, :company_dimension_id
    remove_column :dw_acquisition_facts, :out_stock_info_dimension_id


    add_column :dw_out_of_stock_facts, :stock_out_inventory_id, :integer, index: true, comment: "出库表ID"
    add_column :dw_out_of_stock_facts, :stock_out_inventory_type, :string, index: true, comment: "出库类型"
    add_column :dw_out_of_stock_facts, :stock_out_at_dimension_id, :integer, index: true, comment: "出库时间纬度ID"
    add_column :dw_out_of_stock_facts, :mode, :string, index: true, comment: "出库方式"
    add_column :dw_out_of_stock_facts, :seller_id, :integer, comment: "销售员"
    add_column :dw_out_of_stock_facts, :closing_cost_cents, :bigint, default: 0, comment: "成交价"
    add_column :dw_out_of_stock_facts, :commission_cents, :bigint, default: 0, comment: "佣金"
    add_column :dw_out_of_stock_facts, :refund_price_cents, :bigint, default: 0, comment: "退回车价"
    add_column :dw_out_of_stock_facts, :current, :boolean, default: false, comment: "当前清单"
    remove_column :dw_out_of_stock_facts, :company_dimension_id
    remove_column :dw_out_of_stock_facts, :out_stock_info_dimension_id


    add_column :dw_car_dimensions, :shop_dimension_id, :integer, index: true, comment: "分店纬度ID"
    remove_column :dw_car_dimensions, :shop_id
    remove_column :dw_car_dimensions, :operation_record_count
    change_column_default :dw_car_dimensions, :prepare_items_total_amount_cents, 0

    drop_table :dw_customer_creation_facts
    drop_table :dw_customer_creation_info_dimensions
    drop_table :dw_intention_creation_facts
    drop_table :dw_intention_info_dimensions
    drop_table :dw_operation_creation_dimensions
    drop_table :dw_operation_creation_facts
    drop_table :dw_reservation_facts
    drop_table :dw_reservation_info_dimensions
  end
end
