class AddCompanyIdToAcquisitionCarInfo < ActiveRecord::Migration
  def change
    add_column :acquisition_car_infos, :company_id, :integer, index: true, comment: "发布者所属公司"
  end
end
