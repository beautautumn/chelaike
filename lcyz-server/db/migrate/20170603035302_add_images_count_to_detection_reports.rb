class AddImagesCountToDetectionReports < ActiveRecord::Migration
  def change
    add_column :detection_reports, :images_count, :integer
  end
end
