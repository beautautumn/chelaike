class CreateParallelPhones < ActiveRecord::Migration
  def change
    create_table :parallel_phones, comment: "平行进口车客服电话" do |t|
      t.string :number, comment: "电话号码"

      t.timestamps null: false
    end
  end
end
