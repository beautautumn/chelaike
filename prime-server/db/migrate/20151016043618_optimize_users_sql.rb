class OptimizeUsersSql < ActiveRecord::Migration
  def change
    add_index :users, [:state, :deleted_at], unique: true, where: "state = 'enabled' AND deleted_at IS NULL"
  end
end
