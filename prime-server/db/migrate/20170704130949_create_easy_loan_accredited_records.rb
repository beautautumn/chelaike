class CreateEasyLoanAccreditedRecords < ActiveRecord::Migration
  def change
    create_table :easy_loan_accredited_records, comment: "公司授信记录" do |t|
      t.integer :company_id, comment: "被授信车商公司id"
      t.bigint :limit_amount_cents, comment: "额度"
      t.bigint :in_use_amount_cents, comment: "已用额度"
      t.integer :funder_company_id, comment: "资金方公司id"

      t.timestamps null: false
    end
  end
end
