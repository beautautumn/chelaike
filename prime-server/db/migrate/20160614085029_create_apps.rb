class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :alias
      t.string :logo
      t.string :slogan
      t.string :domain
      t.string :pc_url

      t.timestamps null: false
    end
  end
end
