class AddSourceToIntention < ActiveRecord::Migration
  def change
    add_column :intentions, :source, :string, default: "user_operation", comment: "意向产生来源"
  end
end
