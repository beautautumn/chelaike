class AddAcquisitionTypeToDwAcquisitionInfoDimensions < ActiveRecord::Migration
  def change
    add_column :dw_acquisition_info_dimensions, :acquisition_type, :string, index: true, comment: "收购类型"
  end
end


