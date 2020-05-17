class CreateAllianceInvitations < ActiveRecord::Migration
  def change
    create_table :alliance_invitations do |t|

      t.integer :alliance_id, index: true, comment: "联盟ID"
      t.integer :company_id, index: true, comment: "公司ID"
      t.string :state, default: "unprocessed", comment: "邀请状态"
      t.integer :assignee_id, index: true, comment: "处理人"

      t.timestamps null: false
    end
  end
end
