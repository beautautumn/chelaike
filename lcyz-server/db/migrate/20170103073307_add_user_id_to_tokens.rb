class AddUserIdToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :user_id, :integer, comment: "用户个人的车币"
    add_column :tokens, :token_type, :string, default: "company", comment: "标记个人或公司的车币"

    Token.update_all(token_type: :company)
  end
end
