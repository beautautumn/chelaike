class AddClosingCostCentsToAcquisitionCarInfo < ActiveRecord::Migration
  def change
    add_column :acquisition_car_infos, :closing_cost_cents, :integer, comment: "确认收购价"
  end
end
