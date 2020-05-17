class AddAttachmentToCar < ActiveRecord::Migration
  def change
    add_column :cars, :attachments, :string, array: true, default: [], comment: "车辆附件"
  end
end
