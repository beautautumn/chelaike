class AddStylesCountToParallelBrands < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL
      UPDATE parallel_brands
      SET styles_count = (SELECT count(*) FROM parallel_styles
      WHERE parallel_brand_id = parallel_brands.id)
    SQL

    Car.connection.execute(query.squish!)
  end

  def change
    unless column_exists?(:parallel_brands, :styles_count)
      add_column :parallel_brands, :styles_count, :integer, default: 0, index: true, comment: "车型数量"
    end
  end
end
