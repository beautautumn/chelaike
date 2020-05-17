class AddCurrentPlateNumberToCars < ActiveRecord::Migration
  def change
    add_column :cars, :current_plate_number, :string, index: true, comment: "现车牌(冗余牌证表)"
  end
end
