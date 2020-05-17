class AddOperationRecordIdToAllianceInvitation < ActiveRecord::Migration
  def change
    add_column :alliance_invitations, :operation_record_id, :integer, index: true, comment: "联盟邀请操作记录"
  end
end
