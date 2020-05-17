class CreateEasyLoanMessages < ActiveRecord::Migration
  def change
    create_table :easy_loan_messages, comment: "车融易里的消息" do |t|
      t.integer :user_id, comment: "对应user"
      t.string :user_type, comment: "user多态"
      t.integer :easy_loan_operation_record_id, comment: "对应的车融易里操作记录"

      t.timestamps null: false
    end
  end
end
