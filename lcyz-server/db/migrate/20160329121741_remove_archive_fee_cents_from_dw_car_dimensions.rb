class RemoveArchiveFeeCentsFromDwCarDimensions < ActiveRecord::Migration
  def change
    remove_column :dw_car_dimensions, :sale_archive_fee_cents
    remove_column :dw_car_dimensions, :acquisition_archive_fee_cents
    remove_column :dw_car_dimensions, :sale_transfer_fee_cents
    remove_column :dw_car_dimensions, :acquisition_transfer_fee_cents

    add_column :dw_car_dimensions, :sale_total_transfer_fee_cents, :bigint, comment: "销售过户总费用"
    add_column :dw_car_dimensions, :acquisition_total_transfer_fee_cents, :bigint, comment: "收购过户总费用"

    add_column :transfer_records, :total_transfer_fee_cents, :bigint, comment: "过户总费用"
    add_column :stock_out_inventories, :total_transfer_fee_cents, :bigint, comment: "过户总费用"
  end
end
