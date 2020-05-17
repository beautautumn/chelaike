class OperationRecord < ActiveRecord::Base
  class CreateService
    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def loan_bill_state_updated_record(loan_bill)
      class_name = loan_bill.class.name.demodulize
      return unless class_name.in?(%w(LoanBill))

      loan_bill.operation_records.create!(
        user: user,
        company_id: loan_bill.company_id,
        operation_record_type: :loan_bill_state_updated,
        shop_id: loan_bill.shop_id,
        messages: {
          loan_bill_id: loan_bill.id,
          title: "库融状态更新",
          car_name: loan_bill.car.system_name,
          bill_state: loan_bill.state,
          state_text: loan_bill.state_text,
          state_message_text: loan_bill.state_message_text,
          funder_company_name: loan_bill.funder_company.name,
          note: loan_bill.latest_state_history.try(:note)
        }
      )
    end

    def accredited_updated_record(accredited)
      accredited.operation_records.create!(
        user: user,
        company_id: accredited.company_id,
        operation_record_type: :accredited_updated,
        shop_id: accredited.shop_id,
        messages: {
          accredited_record_id: accredited.id,
          title: "授信额度调整",
          funder_company_name: accredited.funder_company_name,
          current_limit_amount_wan: accredited.limit_amount_wan,
          latest_limit_amout_wan: accredited.latest_limit_amout_wan
        }
      )
    end

    def debit_updated_record(debit)
      debit.operation_records.create!(
        user: user,
        company_id: debit.company_id,
        operation_record_type: :debit_updated,
        shop_id: debit.shop_id,
        messages: {
          debit_id: debit.id,
          title: "库融评级发布",
          comprehensive_rating: debit.comprehensive_rating,
          inventory_amount: debit.inventory_amount,
          operating_health: debit.operating_health,
          industry_rating: debit.industry_rating,
          beat_global: debit.beat_global,
          beat_local: debit.beat_local
        }
      )
    end

    # 新版车容易里借款单状态变化的消息记录
    def che_rong_yi_loan_bill_state_updated_record(loan_bill)
      OperationRecord.create!(
        targetable_id: loan_bill.id,
        targetable_type: "CheRongYi::LoanBill",
        user: nil, # 操作人ID，这里应该是得不到
        company_id: loan_bill.shop_id, # 车融易里存的shop_id就是车来客里的company_id
        operation_record_type: :loan_bill_state_updated,
        shop_id: nil,
        messages: {
          loan_bill_id: loan_bill.id,
          title: "库融状态更新",
          car_name: loan_bill.cars_name_by_id,
          bill_state: loan_bill.state,
          state_text: loan_bill.state_text,
          state_message_text: loan_bill.state_message_text,
          funder_company_name: loan_bill.funder_company_name,
          borrowed_amount_wan: loan_bill.borrowed_amount_wan,
          note: loan_bill.latest_history_note
        }
      )
    end

    # 新版车容易更新授信记录消息
    def che_rong_yi_accredited_updated_record(accredited_records)
      accredited = accredited_records.first
      OperationRecord.create!(
        targetable_id: accredited.id,
        targetable_type: "CheRongYi::LoanAccreditedRecord",
        user: nil, # 操作人
        # company_id: nil, # 所属平台
        company_id: accredited.debtor_id, # 车融易里的shop_id对应company_id
        operation_record_type: :accredited_updated,
        # shop_id: accredited.shop_id,
        shop_id: nil,
        messages: {
          accredited_record_id: accredited.id,
          title: "授信额度调整",
          funder_company_name: accredited.funder_company_name,
          current_limit_amount_wan: accredited.limit_amount_wan,
          latest_limit_amout_wan: accredited.latest_limit_amout_wan,
          show_text: accredited_records.map(&:show_text).join("；")
        }
      )
    end

    # 车容易里换车单状态更新消息
    def replace_car_state_record(replace_cars_bill)
      OperationRecord.create!(
        targetable_id: replace_cars_bill.id,
        targetable_type: "CheRongYi::ReplaceCarsBill",
        user: nil, # 操作人
        # company_id: nil, # 所属平台
        company_id: replace_cars_bill.debtor_id, # 车融易里的
        operation_record_type: :replace_cars_updated,
        # shop_id: replace_cars_bill.debtor_id,
        shop_id: nil,
        messages: {
          loan_bill_code: replace_cars_bill.loan_bill_code,
          replace_cars_bill_id: replace_cars_bill.id,
          title: "换车状态更新",
          original_cars: replace_cars_bill.original_cars_name, # 原借款车辆
          new_cars: replace_cars_bill.new_cars_name, # 替换车辆
          state: replace_cars_bill.state, # 换车单状态
          state_text: replace_cars_bill.state_text, # 换车单状态文字
          funder_company_name: replace_cars_bill.funder_company_name
        }
      )
    end

    # 平台发送的公告消息
    def system_announcement_record(announcement)
      company_id = announcement.company_id if announcement.sender_market?

      announcement.operation_records.create!(
        user: user,
        company_id: company_id,
        operation_record_type: :system_announcement,
        shop_id: nil,
        messages: {
          announcement_id: announcement.id,
          title: "系统公告",
          announcement_title: announcement.title,
          announcement_content: announcement.content,
          announcement_time: announcement.created_at.strftime("%Y-%m-%d %H:%M")
        }
      )
    end

    # 检测状态对应的操作记录
    %w(first_reported verified unverified).each do |detection_state|
      define_method "#{detection_state}_record" do |car|
        title = {
          first_reported: "库存消息",
          verified: "库存消息",
          unverified: "库存消息"
        }.fetch(detection_state.to_sym)

        car.operation_records.create!(
          user: user,
          company_id: user.company_id,
          operation_record_type: detection_state.to_sym,
          shop_id: car.shop_id,
          messages: {
            car_id: car.id,
            title: title,
            car_name: car.name,
            stock_number: car.stock_number
          }
        )
      end
    end

    # 初检派单生成后通知被指派者
    # user是接收消息的用户
    def first_check_appointment_record(first_check_appointment)
      first_check_appointment.operation_records.create!(
        user: user,
        company_id: user.company_id,
        operation_record_type: :first_check_appointment,
        shop_id: user.shop_id,
        messages: {
          first_check_appointment_id: first_check_appointment.id,
          title: "初检派单",
          first_check_appointment_title: first_check_appointment.shop_name,
          first_check_appointment_content: first_check_appointment.gate_log_images,
          first_check_appointment_time: first_check_appointment.created_at.strftime(
            "%Y-%m-%d %H:%M"
          )
        }
      )
    end
  end
end
