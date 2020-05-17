class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens, comment: "车币" do |t|
      t.integer :company_id
      t.float :balance, default: 0
    end

    drop_table :maintenance_limits
  end
end
