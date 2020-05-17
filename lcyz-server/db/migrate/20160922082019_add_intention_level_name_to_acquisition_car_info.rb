class AddIntentionLevelNameToAcquisitionCarInfo < ActiveRecord::Migration
  def change
    add_column :acquisition_car_infos, :intention_level_name, :string, comment: "客户等级"

    AcquisitionCarInfo.all.each do |info|
      if info.owner_info.present?
        intention_level = info.owner_info.fetch("intention_level", {})
        if intention_level.present?
          info.update_columns(intention_level_name: intention_level.fetch("name", ""))
        end
      end
    end
  end
end
