class CreateTokenPackages < ActiveRecord::Migration
  def change
    create_table :token_packages, comment: "车币套餐" do |t|
      t.string :name, comment: "名称"
      t.string :title, comment: "标题"
      t.string :description, comment: "描述"
      t.integer :price_cents, comment: "价格"
      t.integer :balance, comment: "车币"
      t.integer :extra_balance, comment: "赠送车币"
    end

    drop_table :maintenance_packages
  end
end
