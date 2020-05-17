class CreateEasyLoanOperationRecords < ActiveRecord::Migration
  def change
    create_table :easy_loan_operation_records, comment: "车融易用户操作记录" do |t|
      t.references :targetable, polymorphic: true, comment: "操作对象"
      t.string :operation_record_type, comment: "事件类型"
      t.integer :user_id, comment: "操作人ID"
      t.jsonb :messages, comment: "操作信息"
      t.integer :sp_company_id, comment: "对应所属sp公司"

      t.timestamps null: false
    end
  end
end
