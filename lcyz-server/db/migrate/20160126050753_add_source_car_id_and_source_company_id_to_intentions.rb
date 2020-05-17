class AddSourceCarIdAndSourceCompanyIdToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :source_car_id, :integer, index: true, comment: "来源车辆ID"
    add_column :intentions, :source_company_id, :integer, index: true, comment: "来源公司ID"
  end
end
