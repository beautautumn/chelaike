class CreateAcquisitionCarComments < ActiveRecord::Migration
  def change
    create_table :acquisition_car_comments, comment: "收车信息的回复" do |t|
      t.integer :commenter_id, index: true, foreign_key: true, comment: "信息回复者的ID"
      t.integer :company_id, index: true, foreign_key: true, comment: "回复者所在公司"
      t.references :acquisition_car, index: true, foreign_key: true, comment: "所属的收车信息"
      t.integer :valuation, comment: "回复人的估价"
      t.jsonb :note, comment: "备注，文字及语音"
      t.boolean :cooperate, comment: "合作收车"
      t.boolean :is_seller, comment: "是否成为销售方"

      t.timestamps null: false
    end
  end
end
