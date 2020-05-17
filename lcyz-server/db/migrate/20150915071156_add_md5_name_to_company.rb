class AddMd5NameToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :md5_name, :string, index: true, comment: "兼容老系统的名称MD5值"
  end
end
