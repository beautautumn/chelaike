class CreateOperationCreationFacts < ActiveRecord::Migration
  def change
    create_table :operation_creation_facts, comment: "操作历史创建事实" do |t|

      t.integer :operation_record_id, index: true, comment: "操作历史ID"
      t.integer :company_dimension_id, index: true, comment: "公司维度ID"
      t.integer :creation_dimension_id, index: true, comment: "操作历史创建维度ID"

      t.timestamps null: false
    end
  end
end
