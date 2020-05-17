class AddMoreCentsToDw < ActiveRecord::Migration
  def change
    add_column :dw_out_of_stock_facts, :other_fee_cents, :bigint, default: 0, comment: "其他费用"

    add_column :dw_car_dimensions, :sale_archive_fee_cents, :bigint, default: 0, comment: "销售过户-提档费"
    add_column :dw_car_dimensions, :sale_transfer_fee_cents, :bigint, default: 0, comment: "销售过户-过户费"
    add_column :dw_car_dimensions, :acquisition_archive_fee_cents, :bigint, default: 0, comment: "收购过户-提档费"
    add_column :dw_car_dimensions, :acquisition_transfer_fee_cents, :bigint, default: 0, comment: "收购过户-过户费"
  end
end
