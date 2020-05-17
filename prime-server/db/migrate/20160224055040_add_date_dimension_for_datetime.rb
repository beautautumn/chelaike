class AddDateDimensionForDatetime < ActiveRecord::Migration
  def change
    add_column :dw_acquisition_info_dimensions, :acquired_at_date, :date, comment: "收购日期"
    add_column :dw_customer_creation_info_dimensions, :created_at_date, :date, comment: "创建日期"
    add_column :dw_intention_info_dimensions, :intention_created_at_date, :date, comment: "意向创建日期"
    add_column :dw_operation_creation_dimensions, :operation_created_at_date, :date, comment: "操作历史创建日期"
    add_column :dw_reservation_info_dimensions, :reserved_at_date, :date, comment: "预定日期"
  end
end
