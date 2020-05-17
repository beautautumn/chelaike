class AddVersionCategoryToAppVersion < ActiveRecord::Migration
  def change
    add_column :app_versions, :version_category, :string, default: "prime", comment: "版本类别，如车来客与鸿升车来客"
  end
end
