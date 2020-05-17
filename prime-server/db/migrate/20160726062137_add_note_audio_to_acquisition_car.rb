class AddNoteAudioToAcquisitionCar < ActiveRecord::Migration
  def change
    remove_column :acquisition_cars, :note
    add_column :acquisition_cars, :note_text, :text, comment: "文字备注"
    add_column :acquisition_cars, :note_audio, :string, array: true, comment: "多条语音备注"

    remove_column :acquisition_car_comments, :note
    add_column :acquisition_car_comments, :note_text, :text, comment: "文字备注"
    add_column :acquisition_car_comments, :note_audio, :string, array: true, comment: "多条语音备注"
  end
end
