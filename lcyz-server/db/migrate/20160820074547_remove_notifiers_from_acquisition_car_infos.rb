class RemoveNotifiersFromAcquisitionCarInfos < ActiveRecord::Migration
  def change
    remove_columns :acquisition_car_infos, :notifiers, :image_url, :note_audio
    add_column :acquisition_car_infos, :key_count, :integer, comment: "车辆钥匙数"
    add_column :acquisition_car_infos, :images, :jsonb, array: true, default: [], comment: "多张图片信息"
    add_column :acquisition_car_infos, :owner_info, :jsonb, comment: "原车主信息"
    add_column :acquisition_car_infos, :is_turbo_charger, :boolean, default: false, comment: "是否自然排气"
    add_column :acquisition_car_infos, :note_audios, :jsonb, array: true, default: [], comment: "多条语音备注"
    add_column :acquisition_car_infos, :configuration_note, :string, comment: "配置说明"
    add_column :acquisition_car_infos, :procedure_items, :jsonb, comment: "手续信息"
    add_column :acquisition_car_infos, :license_info, :string, comment: "牌证信息"
  end
end
