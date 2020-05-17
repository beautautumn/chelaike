class AddAllianceCompanyIdToAlliance < ActiveRecord::Migration
  def change
    add_reference :alliances, :alliance_company, index: true, foreign_key: true, comment: "外键关联联盟公司"
  end
end
