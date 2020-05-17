class CreateEasyLoanCities < ActiveRecord::Migration
  def change
    create_table :easy_loan_cities, comment: "车融易地区" do |t|
      t.string :name, comment: "地区中文名称"
      t.string :pinyin, comment: "地区拼音"
      t.string :zip_code, comment: "地区邮编"
      t.json :scope, default: {}, comment: "城市综合指数最小／最大／最可能分"

      t.timestamps null: false
    end
  end
end
