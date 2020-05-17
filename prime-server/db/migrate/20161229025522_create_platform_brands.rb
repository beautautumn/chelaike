class CreatePlatformBrands < ActiveRecord::Migration
  def change
    create_table :platform_brands do |t|
      t.integer :platform_code
      t.string :brand_name
      t.string :brand_code
      t.bigint :price
      t.time :start_time
      t.time :end_time
      t.boolean :need_engine_number
      t.string :mode
      t.string :comment

      t.timestamps null: false
    end
  end
end
