class CreateOwnerCompanies < ActiveRecord::Migration
  def change
    create_table :owner_companies, comment: "归属车商" do |t|
      t.string :name, comment: "车商名"

      t.timestamps null: false
    end
  end
end
