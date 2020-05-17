class CreateDwIntentionCreationFacts < ActiveRecord::Migration
  def change
    create_table :dw_intention_creation_facts, comment: "意向创建事实" do |t|
      t.integer :intention_id, index: true, comment: "意向ID"
      t.integer :intention_info_dimension_id, comment: "意向信息维度ID"
      t.integer :company_dimension_id, index: true, comment: "公司维度ID"
      t.integer :customer_dimension_id, index: true, comment: "客户维度ID"
      t.integer :customer_dimension_id, index: true, comment: "客户维度ID"

      t.timestamps null: false
    end

    add_index :dw_intention_creation_facts, :intention_info_dimension_id, name: "index_dicf_on_intention_info_dimension_id"
  end
end
