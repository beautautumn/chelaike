# == Schema Information
#
# Table name: operation_records # 操作历史
#
#  id                    :integer          not null, primary key # 操作历史
#  targetable_id         :integer                                # 多态ID
#  targetable_type       :string                                 # 多态类型
#  operation_record_type :string                                 # 事件类型
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer                                # 操作人ID
#  messages              :jsonb                                  # 操作信息
#  company_id            :integer                                # 公司ID
#  shop_id               :integer                                # 店ID
#  detail                :jsonb                                  # 详情
#  user_type             :string           default("User")
#  user_passport         :jsonb                                  # 操作用户信息
#

class OperationRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  extend EnumerizeWithGroups
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :targetable, polymorphic: true
  belongs_to :user, polymorphic: true
  belongs_to :company
  # validations ...............................................................
  # callbacks .................................................................
  after_commit :create_messages, on: :create
  # scopes ....................................................................
  scope :ordered, -> { order(id: :desc) }
  scope :stock_out, -> (type) { where("messages->>'stock_out_type' = ?", type) }
  scope :valid, lambda {
    where(
      operation_record_type: %i(
        car_created car_updated state_changed car_priced
        car_reserved car_reservation_canceled prepare_record_updated
        stock_out stock_back alliance_stock_out alliance_stock_back
        intention_reassigned maintenance_fetch_success maintenance_fetch_fail token_recharge
        car_price_updated alliance_stock_in assigned_acquisition_car_info
      )
    )
  }

  # additional config .........................................................
  enumerize :operation_record_type,
            in: %i(
              car_created car_updated car_deleted state_changed car_priced
              car_reserved car_reservation_canceled prepare_record_updated
              stock_out stock_back alliance_stock_out alliance_stock_back
              alliance_invitation_created
              alliance_relationship_deleted alliance_relationship_quit
              alliance_invitation_agreed alliance_invitation_disagreed
              intention_reassigned remind_intention_untreated remind_intention_due
              daily_report alliance_cars_created_statistic
              maintenance_fetch_success maintenance_fetch_fail token_recharge
              insurance_fetch_success insurance_update_success insurance_fetch_fail
              car_price_updated alliance_stock_in
              prepare_finish service_notification stock_warning
              assigned_acquisition_car_info
              remind_restock vin_image_fail vin_image_request
              expiration_notification loan_bill_state_updated
              accredited_updated debit_updated
            ),
            groups: {
              cars: %i(
                car_created car_deleted state_changed car_priced
                car_reserved car_reservation_canceled
                stock_out stock_back
                remind_restock
              ),
              messagable: %i(
                car_created state_changed car_priced car_reserved
                car_reservation_canceled stock_out car_deleted
                stock_back alliance_stock_out alliance_stock_back
                alliance_stock_in prepare_finish
                stock_warning remind_restock
              ),
              alliance_messagable: %i(
                alliance_invitation_created
                alliance_relationship_deleted alliance_relationship_quit
                alliance_invitation_agreed alliance_invitation_disagreed
              ),
              intention_messagable: %i(
                intention_reassigned remind_intention_untreated
                remind_intention_due service_notification
                assigned_acquisition_car_info expiration_notification
              ),
              solo_messagble: %i(
                maintenance_fetch_success maintenance_fetch_fail token_recharge
                insurance_fetch_success insurance_update_success insurance_fetch_fail
                vin_image_fail vin_image_request
              ),
              statistics: %i(daily_report alliance_cars_created_statistic),
              loan_messagable: %i(loan_bill_state_updated accredited_updated debit_updated)
            }

  ransacker :created_at do
    Arel.sql("date(#{table_name}.created_at AT TIME ZONE 'GMT+8')")
  end
  # class methods .............................................................
  def self.messagable_types
    operation_record_type_messagable + operation_record_type_alliance_messagable +
      operation_record_type_statistics + operation_record_type_intention_messagable +
      operation_record_type_solo_messagble + operation_record_type_loan_messagable
  end

  # public instance methods ...................................................
  def operation_record_type_icon
    scope = "enumerize.operation_record.operation_record_type_icon"

    icon_name = if operation_record_type == "stock_out"
      I18n.t("#{scope}.stock_out.#{messages["stock_out_type"]}")
    else
      I18n.t("#{scope}.#{operation_record_type}")
    end

    "#{ENV.fetch("OSS_BUCKET_HOST")}/message-icons/#{icon_name}"
  end

  def operation_record_type_color
    scope = "enumerize.operation_record.operation_record_type_color"

    if operation_record_type == "stock_out"
      I18n.t("#{scope}.stock_out.#{messages["stock_out_type"]}")
    else
      I18n.t("#{scope}.#{operation_record_type}")
    end
  end

  def message_text(notification_alert: false)
    OperationRecord::MessageTextService.new(
      self, notification_alert: notification_alert
    ).execute
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def message_type
    return RongMessageService::MESSAGE_STOCK if in_operation_record_type_messagable?
    return RongMessageService::MESSAGE_SYSTEM if in_operation_record_type_alliance_messagable?
    return RongMessageService::MESSAGE_CUSTOMER if in_operation_record_type_intention_messagable?
    return RongMessageService::MESSAGE_SYSTEM if in_operation_record_type_solo_messagble?
    return RongMessageService::MESSAGE_STATISTICS if in_operation_record_type_statistics?
    return RongMessageService::MESSAGE_LOAN if in_operation_record_type_loan_messagable?
  end

  def intention_message_text
    case operation_record_type
    when "intention_reassigned"
      intention_reassigned_message_text
    when "remind_intention_untreated"
      remind_intention_untreated_message_text
    when "remind_intention_due"
      remind_intention_due_message_text
    when "assigned_acquisition_car_info"
      assigned_acquisition_car_info_message_text
    when "expiration_notification"
      messages.fetch("text")
    end
  end

  def director_assignee?
    return true if messages["assignee_id_was"].blank?
    user_id == messages["assignee_id_was"].to_i
  end

  def intention_reassigned_message_text
    if director_assignee?
      I18n.t(
        "operation_record.messages.intention_reassigned.assigned".freeze,
        user_name: messages["user_name"],
        customer_name: messages["customer_name"]
      )
    else
      assignee = User.find_by(id: messages["assignee_id"])
      assignee_was = User.find_by(id: messages["assignee_id_was"])
      I18n.t(
        "operation_record.messages.intention_reassigned.reassigned".freeze,
        user_name: messages["user_name"],
        customer_name: messages["customer_name"],
        assignee_was: assignee_was.try(:name),
        assignee: assignee.try(:name)
      )
    end
  end

  def remind_intention_untreated_message_text
    I18n.t(
      "operation_record.messages.remind_intention_untreated".freeze,
      customer_name: messages["customer_name"]
    )
  end

  def remind_intention_due_message_text
    I18n.t(
      "operation_record.messages.remind_intention_due".freeze,
      customer_name: messages["customer_name"]
    )
  end

  def assigned_acquisition_car_info_message_text
    I18n.t(
      "operation_record.messages.assigned_acquisition_car_info".freeze,
      user_name: messages["user_name"]
    )
  end

  def detail_text(user)
    case operation_record_type
    when "car_updated"
      car_updated_detail(user)
    else
      messages["title"] # 默认显示事件名
    end
  end

  def alliance_message_text
    I18n.t(
      "operation_record.messages.#{operation_record_type}",
      company_name: messages["company_name"],
      alliance_name: messages["alliance_name"],
      type: operation_record_type
    )
  end

  def loan_message_text
    extra_params = case operation_record_type
                   when "loan_bill_state_updated"
                     {
                       car_name: messages["car_name"],
                       funder_company_name: messages["funder_company_name"],
                       state_text: messages["state_text"],
                       state_message_text: messages["state_message_text"],
                       note: messages["note"]
                     }
                   when "accredited_updated"
                     {
                       funder_company_name: messages["funder_company_name"],
                       latest_limit_amout_wan: messages["latest_limit_amout_wan"],
                       current_limit_amount_wan: messages["current_limit_amount_wan"]
                     }
                   when "debit_updated"
                     {
                       comprehensive_rating: messages["comprehensive_rating"],
                       inventory_amount: messages["inventory_amount"],
                       operating_health: messages["operating_health"],
                       industry_rating: messages["industry_rating"]
                     }
                   end

    I18n.t(
      "operation_record.messages.#{operation_record_type}",
      extra_params
    )
  end

  def message_notify_authority
    case operation_record_type
    when "car_reserved", "car_reservation_canceled"
      %w(求购客户跟进)
    when "prepare_finish"
      %w(整备信息录入)
    when "stock_warning"
      %w(车辆销售定价 收购价格查看)
    when *self.class.operation_record_type_loan_messagable.map(&:to_s)
      %w(融资管理)
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def car_priced_notify_filter?
    now = messages.slice(
      "manager_price_wan",
      "alliance_minimun_price_wan"
    ).values
    previous = messages.slice(
      "previous_manager_price_wan",
      "previous_alliance_minimun_price_wan"
    ).values
    now != previous
  end

  def car_updated_detail(user)
    cache_key = "operation_record:car_updated_detail:#{id}:#{user.cache_uuid}"

    Rails.cache.fetch(cache_key) do
      car_detail = detail.fetch("car", {})
      acquisition_transfer_detail = detail.fetch("acquisition_transfer", {})

      name_only = (car_detail.size + acquisition_transfer_detail.size) > 3

      arr = []
      arr << ObjectDiff::Car.new(targetable).text_for(user, car_detail, name_only: name_only)

      if User::Pundit.filter(user, targetable, ["牌证信息查看"])
        arr << ObjectDiff::TransferRecord
               .new(targetable.acquisition_transfer)
               .text_for(user, acquisition_transfer_detail, name_only: name_only)
      end

      arr.flatten.compact
    end
  end

  def create_messages
    create_car_messages       if in_operation_record_type_messagable?
    create_alliance_messages  if in_operation_record_type_alliance_messagable?
    create_intention_messages if in_operation_record_type_intention_messagable?
    create_solo_messages      if in_operation_record_type_solo_messagble?
    create_loan_messages      if in_operation_record_type_loan_messagable?
  end

  def create_intention_messages
    IntentionMessageWorker.perform_in(5.seconds, id)
  end

  def create_car_messages
    MessageWorker.perform_in(5.seconds, id)
  end

  def create_alliance_messages
    AllianceMessageWorker.perform_in(5.seconds, id)
  end

  def create_solo_messages
    MessageWorker.perform_in(5.seconds, id, true)
  end

  # 创建金融消息
  def create_loan_messages
    LoanMessageWorker.perform_in(5.seconds, id)
  end
end
