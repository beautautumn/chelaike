class AddNameToCars < ActiveRecord::Migration
  def migrate(dir)
    super

    query = <<-SQL
      UPDATE cars SET name = brand_name || ' ' || series_name || ' ' || style_name
    SQL
    Car.connection.execute(query.squish!)
  end

  def change
    add_column :cars, :name, :string, index: true, comment: "车辆名称"
  end
end
