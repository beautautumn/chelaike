class OptimizeCarsSql < ActiveRecord::Migration
  def change
    add_index :cars, [:state, :company_id]
    add_index :cars, [:deleted_at, :reserved], unique: true, where: "(deleted_at IS NULL) AND (NOT reserved)"
  end
end
