class AddIntentionLevelRelatedAttributes < ActiveRecord::Migration
  def change
    add_column :intention_levels, :company_type, :string, default: "Company", comment: "所属公司类型"
    add_column :intentions, :alliance_intention_id, :integer, comment: "联盟客户级别"
  end
end
