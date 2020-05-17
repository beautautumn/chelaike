class AddErpUrlAndErpIdToErpApis < ActiveRecord::Migration
  def change
    add_column :companies, :erp_id, :string, comment: "ERP 识别号"
    add_column :companies, :erp_url, :string, comment: "ERP 通知地址"
  end
end
