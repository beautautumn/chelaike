class AddCompanyIdToImportTasks < ActiveRecord::Migration
  def change
    add_column :import_tasks, :company_id, :integer, index: true, comment: "公司ID"
  end
end
