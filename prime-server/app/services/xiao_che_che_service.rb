class XiaoCheCheService
  class << self
    # 正常方法入口
    def execute(message_text, ids_text = nil)
      users = if ids_text.present?
                ids = ids_text.gsub(/\s+/, "").split(",")
                User.where(id: ids)
              else
                User.where("current_sign_in_at > ?", Time.zone.today - 60)
              end

      total_ids = users.pluck(:id)

      groups = total_ids.each_slice(6000)
      groups.each_with_index do |group, index|
        base_period = index * 60
        to_send_groups = group.each_slice(1000)
        to_send_groups.each_with_index do |to_group, internal_index|
          internal_period = internal_index * 8
          perform_time = base_period + internal_period
          XiaoCheCheMessageWorker.perform_in(perform_time.seconds, to_group, message_text)
        end
      end
    end

    # 给worker 调用入口
    def publish_message(to_user_ids, message_text)
      Util::RongPush.new(
        from_user_id,
        to_user_ids,
        content_info(message_text)
      ).private_send
    end

    def content_info(text)
      { content: text }
    end

    private

    def from_user_id
      company_id = Rails.env == "production" ? 6 : 4
      User.where(company_id: company_id, username: "小车车").first.id
    end
  end
end
