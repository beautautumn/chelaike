class AddBrandTypeToParallelBrands < ActiveRecord::Migration
  def change
    add_column :parallel_brands, :brand_type, :string,
                comment: "品牌类型(平行进口车/厂家特价车)"
  end
end
