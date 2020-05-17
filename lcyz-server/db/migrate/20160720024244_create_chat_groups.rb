class CreateChatGroups < ActiveRecord::Migration
  def change
    create_table :chat_groups do |t|
      t.references :organize, polymorphic: true, comment: "所属组织"
      t.string :name, null: false, comment: "群组名称"
      t.string :state, null: false, default: "enable", comment: "群组状态"
      t.string :group_type, null: false, default: "sale", comment: "群组类型"
      t.integer :owner_id, index: true, null: false, comment: "群主"
      t.timestamps null: false
    end

    add_index :chat_groups, [:organize_id, :organize_type, :group_type],
              unique: true, name: "uni_chat_group_organize"
  end
end
