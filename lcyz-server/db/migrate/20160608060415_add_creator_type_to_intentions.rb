class AddCreatorTypeToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :creator_type, :string, comment: "意向创建者多态"

    Intention.update_all(creator_type: "User")
  end
end
