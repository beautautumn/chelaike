class AddMemoryDatesToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :memory_dates, :jsonb, comment: "纪念节日"
  end
end
