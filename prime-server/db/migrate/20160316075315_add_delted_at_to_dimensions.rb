class AddDeltedAtToDimensions < ActiveRecord::Migration
  def change
    %i(
      dw_car_dimensions
      dw_company_dimensions
      dw_intention_info_dimensions
    ).each do |table|
      add_column table, :deleted_at, :datetime, comment: "删除时间"
    end
  end
end
