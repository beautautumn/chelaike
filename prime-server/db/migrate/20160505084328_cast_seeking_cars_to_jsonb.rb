class CastSeekingCarsToJsonb < ActiveRecord::Migration
  def change
    sql = <<-SQL.squish!
      alter table intentions
        alter seeking_cars drop default,
        alter seeking_cars SET DATA TYPE jsonb[] using seeking_cars::jsonb[]
    SQL

    execute(sql)

    change_column_default :intentions, :seeking_cars, []
  end
end
