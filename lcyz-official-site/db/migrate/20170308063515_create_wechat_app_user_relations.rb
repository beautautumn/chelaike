class CreateWechatAppUserRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :wechat_app_user_relations, comment: "微信用户与公众号关联表" do |t|
      t.integer :wechat_app_id, index: true, comment: "公众号 ID"
      t.integer :wechat_user_id, index: true, comment: "用户 ID"
      t.integer :group_id, index: true, comment: "分组 ID"
      t.string  :open_id, comment: "用户在每个公众号下的 Open ID"
      t.string  :refresh_token, comment: "refresh_token"
      t.boolean :subscribed, comment: "用户是否关注该应用"
      t.timestamps
    end
  end
end
