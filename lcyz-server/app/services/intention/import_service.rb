class Intention < ActiveRecord::Base
  class ImportService
    class FileInvalid < StandardError; end
    class ValueInvalid < StandardError; end

    HEADER_MAP = {
      "意向类型" => 0,
      "姓名" => 1,
      "联系电话" => 2,
      "性别" => 3,
      "来源" => 4,
      "等级" => 5,
      "归属人" => 6,
      "创建人" => 7,
      "创建日期" => 8,
      "跟进状态" => 9,
      "最新跟进时间" => 10,
      "下次跟进日期" => 11,
      "意向内容" => 12
    }.freeze

    def initialize(import_task)
      @import_task = import_task
      @user = import_task.user
    end

    def execute
      @import_task.update!(state: :processing)

      file_path = @import_task.info.fetch("import_file")
      sheet = self.class.open_sheet(file_path, remote: true)

      import_line_by_line(sheet)
    end

    def ready_to_execute(file)
      check_up(file.path)

      upload(file.path, file.original_filename)

      ImportIntentionsWorker.perform_async(@import_task.id)
    end

    def self.open_sheet(file_path, options = {})
      return Spreadsheet.open(file_path).worksheet(0) if options[:remote].blank?

      io = StringIO.new(open(file_path).read)

      Spreadsheet.open(io).worksheet(0)
    end

    private

    def check_up(file_path)
      sheet = self.class.open_sheet(file_path)

      validate_header(sheet)
    end

    def upload(file_path, original_filename)
      oss_path = AliyunOss.put_assets(
        file_path, original_filename,
        forder: File.join(
          ENV.fetch("OSS_IMPORT_INTENTIONS_DIR"), SecureRandom.hex.to_s
        )
      )

      @import_task.update!(
        info: @import_task.info.merge(
          import_file: oss_path,
          import_file_name: original_filename
        )
      )
    end

    def validate_header(sheet)
      sheet.each do |header|
        raise FileInvalid, "Excel格式错误" unless default_header == header

        break
      end
    end

    def default_header
      HEADER_MAP.keys
    end

    def value_at(row, column)
      value = row[HEADER_MAP.fetch(column)]

      value.is_a?(String) ? value.gsub("--", "") : value
    end

    def import_line_by_line(sheet)
      intentions_imported_count = 0
      invalid_rows = []

      Intention.transaction do
        sheet.each(1) do |row|
          begin
            create_intention_by(row)

            intentions_imported_count += 1
          rescue ValueInvalid => e
            invalid_rows << record_with_error(row, e)
          rescue ActiveRecord::RecordInvalid => e
            invalid_rows << record_with_error(row, e)
          end
        end

        @import_task.update!(
          state: :finished,
          info: @import_task.info.merge(
            total: sheet.row_count - 1,
            intentions_imported_count: intentions_imported_count,
            intentions_failed_count: invalid_rows.size
          )
        )
      end

      make_xls_for_invalid_records(invalid_rows)
    end

    def record_with_error(row, e)
      row = update_for(row, "创建日期") do |value|
        begin
          value.try(:to_date).try(:to_s)
        rescue
          value
        end
      end

      row = update_for(row, "下次跟进日期") do |value|
        begin
          value.try(:to_date).try(:to_s)
        rescue
          value
        end
      end

      row = update_for(row, "最新跟进时间") do |value|
        begin
          value.try { |time| time.strftime("%Y-%m-%d %H:%M") }
        rescue
          value
        end
      end

      row + [e.message]
    end

    def update_for(row, column)
      index = HEADER_MAP.fetch(column)
      value = row[index]

      row[index] = yield(value)

      row
    end

    def make_xls_for_invalid_records(invalid_rows)
      return if invalid_rows.blank?

      Reporter.new(
        @user, :import_intentions_invalid_rows,
        import_task: @import_task, records: invalid_rows
      ).export
    end

    def create_intention_by(row)
      intention = Intention.new(company_id: @user.company_id)

      assignee = find_assignee(value_at(row, "归属人"))
      customer = create_customer(row, assignee)

      intention.assign_attributes(
        attributes(row).merge(
          assignee_id: assignee.try(:id),
          customer_id: customer.id,
          customer_name: customer.name,
          customer_phone: customer.phone
        )
      )

      if assignee.blank?
        intention.state = "untreated"
      else
        check_intention!(assignee, customer, intention)

        intention = create_intention_push_history(
          value_at(row, "最新跟进时间"), intention
        )
      end

      intention.save!
    end

    def check_intention!(assignee, customer, intention)
      Intention::CheckService.new(assignee).check!(
        customer_phones: [customer.phone],
        customer_id: customer.id,
        intention_type: intention.intention_type
      )
    rescue Intention::CheckService::InvalidError => e
      raise ValueInvalid, e.message
    end

    def create_intention_push_history(last_processing_time, intention)
      last_processing_time = if last_processing_time.present?
                               parse_time(last_processing_time)
                             else
                               Time.zone.now
                             end

      intention.intention_push_histories.new(
        state: intention.state,
        created_at: intention.created_at,
        processing_time: last_processing_time,
        intention_level_id: intention.intention_level_id,
        executor_id: intention.assignee_id
      )

      intention
    end

    def create_customer(row, assignee)
      customer_name = parse_customer_name(value_at(row, "姓名"))
      customer_phone = parse_customer_phone(value_at(row, "联系电话"))

      if assignee.present?
        Customer.find_or_create_by!(
          company_id: @user.company_id,
          user_id: assignee.id,
          name: customer_name,
          phone: customer_phone
        )
      else
        Customer.find_or_create_by!(
          company_id: @user.company_id,
          name: customer_name,
          phone: customer_phone
        )
      end
    end

    def attributes(row)
      due_time = parse_time(value_at(row, "下次跟进日期"))
      state = parse_state(value_at(row, "跟进状态").to_s)

      {
        intention_type: parse_intention_type(value_at(row, "意向类型")),
        gender: parse_gender(value_at(row, "性别")),
        channel_id: find_channel(value_at(row, "来源").to_s).try(:id),
        intention_level_id: find_intention_level(value_at(row, "等级").to_s).try(:id),
        creator_id: find_creator(value_at(row, "创建人").to_s).try(:id),
        creator_type: "User",
        created_at: parse_created_at(value_at(row, "创建日期")),
        state: state,
        intention_note: value_at(row, "意向内容").to_s,
        import_task_id: @import_task.id
      }.tap do |hash|
        if state.to_s == "interviewed"
          hash[:interviewed_time] = due_time
        else
          hash[:processing_time] = due_time
        end
      end
    end

    def errors_record(row, error_msg)
      %w(意向类型 姓名 联系电话 意向内容).map { |column| value_at(row, column) }
                           .concat([error_msg])
    end

    def parse_intention_type(intention_type)
      case intention_type
      when "出售"
        "sale"
      when "求购"
        "seek"
      else
        raise ValueInvalid, "意向类型不存在, 只允许 求购/出售"
      end
    end

    def parse_gender(gender)
      case gender
      when "男"
        "male"
      when "女"
        "female"
      end
    end

    def find_channel(name)
      Channel.where(company_id: @user.company_id, name: name).first
    end

    def find_intention_level(name)
      IntentionLevel.where(company_id: @user.company_id, name: name).first
    end

    def find_assignee(name)
      return if name.blank?

      user = User.where(company_id: @user.company_id, name: name).first
      raise ValueInvalid, "归属人不存在" if user.blank?

      user
    end

    def find_creator(name)
      return User::Anonymous if name.blank?

      User.where(company_id: @user.company_id, name: name).first
    end

    def parse_created_at(created_at)
      return Time.zone.now if created_at.blank?

      parse_time(created_at)
    end

    def parse_state(state)
      states.fetch(state) do
        raise ValueInvalid, "意向状态不存在, 只允许: #{states.keys.join(", ")}"
      end
    end

    def states
      @_states ||= {}.tap do |hash|
        I18n.t("enumerize.intention.state").each do |key, value|
          hash[value] = key
        end
      end
    end

    def parse_customer_name(name)
      return name if name.present?

      raise ValueInvalid, "客户姓名不能为空"
    end

    def parse_customer_phone(phone)
      return phone.to_i.to_s if phone.present?

      raise ValueInvalid, "客户电话不能为空"
    end

    def parse_time(time)
      return if time.blank?
      time = time.strftime("%Y-%m-%d %H:%M") unless time.is_a?(String)

      Time.zone.parse(time)
    rescue
      raise ValueInvalid, "时间格式不正确, 例子: 2016-10-10 15:10 或者 2016-10-10"
    end
  end
end
