class ChangeNoteAudioForAcquisitionCarComment < ActiveRecord::Migration
  def change
    remove_column :acquisition_car_comments, :note_audio, :string, array: true, comment: "多条语音备注"
    add_column :acquisition_car_comments, :note_audios, :jsonb, array: true, default: [], comment: "多条语音备注"
  end
end
