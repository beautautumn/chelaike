class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, comment: "用户" do |t|
      t.string :username, comment: "用户名"
      t.string :phone, comment: "手机号"
      t.string :password_digest, comment: "加密密码"

      t.timestamps
    end
  end
end
