class AddExpiredAtToEasyLoanUsers < ActiveRecord::Migration
  def change
    add_column  :easy_loan_users, :expired_at, :datetime, comment: "短信验证码失效时间"
  end
end
