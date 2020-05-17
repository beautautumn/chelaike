class ChangeSateForAllianceInvitation < ActiveRecord::Migration
  def change
    change_column :alliance_invitations, :state, :string, default: "pending", comment: "联盟邀请状态"
  end
end
