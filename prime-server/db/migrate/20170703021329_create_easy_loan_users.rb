class CreateEasyLoanUsers < ActiveRecord::Migration
  def change
    create_table :easy_loan_users,  comment: "车融易用户模型" do |t|
      t.string :phone,  comment: "手机号码"
      t.string :token,  comment: "验证码"

      t.timestamps null: false
    end
  end
end
