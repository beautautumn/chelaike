class CreateDwCustomerCreationFacts < ActiveRecord::Migration
  def change
    create_table :dw_customer_creation_facts, comment: "客户创建事实" do |t|
      t.integer :customer_id, index: true, comment: "客户ID"
      t.integer :customer_creation_info_dimension_id, comment: "客户创建信息维度ID"
      t.integer :customer_dimension_id, index: true, comment: "客户维度ID"
      t.integer :company_dimension_id, index: true, comment: "公司维度ID"

      t.timestamps null: false
    end

    add_index :dw_customer_creation_facts, :customer_creation_info_dimension_id, name: :dw_customer_creation_facts_info_dimension_id
  end
end
