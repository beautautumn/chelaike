class CreateEasyLoanAccreditedRecordHistories < ActiveRecord::Migration
  def change
    create_table :easy_loan_accredited_record_histories, comment: "记录授信变更历史" do |t|
      t.integer :accredited_record_id, comment: "对应授信记录"
      t.bigint :limit_amount_cents, comment: "变更前的授信金额"
      t.decimal :single_car_rate, comment: "变更前的单车比例"

      t.timestamps null: false
    end
  end
end
