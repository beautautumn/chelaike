class CreateEasyLoanRatingStatements < ActiveRecord::Migration
  def change
    create_table :easy_loan_rating_statements, comment: "车融易评级说明" do |t|
      t.integer :score, comment: "分数"
      t.string :rate_type, comment: "评级类型"
      t.text :content, comment: "评级说明内容"

      t.timestamps null: false
    end
  end
end
