class AddStateToAdvertisements < ActiveRecord::Migration
  def change
    add_column :advertisements, :state, :string, default: "enabled", comment: "是否启用"
  end
end
