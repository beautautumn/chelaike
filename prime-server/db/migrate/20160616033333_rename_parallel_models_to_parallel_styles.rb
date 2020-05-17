class RenameParallelModelsToParallelStyles < ActiveRecord::Migration
  def change
    remove_reference :parallel_models, :parallel_brand, index: true, foreign_key: true
    rename_table :parallel_models, :parallel_styles
    rename_column :parallel_styles, :model_type, :style_type
    add_reference :parallel_styles, :parallel_brand, index: true, foreign_key: true, comment: "品牌"
  end
end
