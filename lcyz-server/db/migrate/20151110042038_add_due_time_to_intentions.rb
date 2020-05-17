class AddDueTimeToIntentions < ActiveRecord::Migration
  def change
    add_column :intentions, :due_time, :datetime, index: true, comment: "下次跟进或预约时间"
  end
end
