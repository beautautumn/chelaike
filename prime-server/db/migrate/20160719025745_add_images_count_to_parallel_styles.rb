class AddImagesCountToParallelStyles < ActiveRecord::Migration
  def change
    unless column_exists?(:parallel_styles, :images_count)
      add_column :parallel_styles, :images_count, :integer, default: 0, index: true, comment: "图片数量"
    end
  end
end
