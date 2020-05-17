module ObjectDiff
  class TransferRecord < Base
    COLUMNS = %i(
      state items key_count contact_person contact_mobile original_location_province
      original_location_city current_location_province current_location_city
      original_plate_number current_plate_number new_plate_number original_owner
      original_owner_idcard original_owner_contact_mobile transfer_recevier
      transfer_recevier_idcard new_owner new_owner_idcard new_owner_contact_mobile
      inspection_state user_id estimated_archived_at archive_fee_cents
      estimated_transferred_at transferred_at transfer_fee_cents
      compulsory_insurance_end_at annual_inspection_end_at commercial_insurance_end_at
      commercial_insurance_amount_cents usage_type registration_number transfer_count
      engine_number allowed_passengers_count note user_name
    ).freeze

    def initialize(transfer_record)
      @transfer_record = transfer_record
      @target_klass = ::TransferRecord
    end

    def execute(changed_attributes)
      {}.tap do |hash|
        changed_attributes.dup.extract!(*COLUMNS).each do |key, old_value|
          diff = send(key, old_value)
          next unless diff.present?

          hash[key] = diff
        end
      end
    end

    [
      :archive_fee, :transfer_fee, :commercial_insurance_amount
    ].each do |key|
      define_method "#{key}_cents" do |old_price|
        old_price_yuan = old_price.present? ? (old_price / 100.0).round(4) : nil
        new_price_yuan = @transfer_record.send("#{key}_yuan")

        [
          old_price_yuan.blank? ? "空" : "#{old_price_yuan} 元",
          new_price_yuan.blank? ? "空" : "#{new_price_yuan} 元"
        ].join(" 调整为 ")
      end
    end

    [
      :key_count, :contact_person, :contact_mobile, :original_location_province,
      :original_location_city, :current_location_province, :current_location_city,
      :original_plate_number, :current_plate_number, :new_plate_number, :original_owner,
      :original_owner_idcard, :original_owner_contact_mobile, :transfer_recevier,
      :transfer_recevier_idcard, :new_owner, :new_owner_idcard, :new_owner_contact_mobile,
      :estimated_archived_at, :estimated_transferred_at, :transferred_at,
      :compulsory_insurance_end_at, :annual_inspection_end_at, :commercial_insurance_end_at,
      :registration_number, :transfer_count, :engine_number, :allowed_passengers_count
    ].each do |key|
      define_method key do |old_value|
        [old_value, @transfer_record.send(key)]
      end
    end

    def user_id(id)
      diff_ids([id, @transfer_record.user_id], User)
    end

    [
      :state, :inspection_state, :usage_type
    ].each do |key|
      define_method key do |old_value|
        [locale(key, old_value), @transfer_record.send("#{key}_text")]
      end
    end

    def note(_old_value)
      ObjectDiff::Base::CHANGED_NOTE
    end

    def items(old_array)
      return "删除 所有的手续项目" unless @transfer_record.items.present?

      transfer_record_items = @transfer_record.items.to_a

      if old_array.present?
        organize_items(transfer_record_items, old_array)
      else
        items_added = transfer_record_items.map { |item| locale(:items, item) }
        return "增加了几个项目" if items_added.size > 3

        "增加 #{items_added.join("、")}"
      end
    end

    def organize_items(items_array, old_array)
      attachments_added = (items_array - old_array).map { |item| locale(:items, item) }
      attachments_removed = (old_array - items_array).map { |item| locale(:items, item) }

      arr = []
      arr << "增加 #{attachments_added.join("、")}" if attachments_added.present?
      arr << "删除 #{attachments_removed.join("、")}" if attachments_removed.present?

      return "修改了几个项目" if arr.size > 3

      arr.join(", ")
    end

    def locale(key, value)
      I18n.t("enumerize.transfer_record.#{key}.#{value}")
    end

    def keys_filter(user)
      keys = COLUMNS.map(&:to_s)

      unless user.id == @acquisition_transfer.try(:user_id) ||
             User::Pundit.filter(user, @acquisition_transfer, ["牌证信息查看"])
        keys -= [:original_owner, :original_owner_idcard]
      end

      keys
    end
  end
end
