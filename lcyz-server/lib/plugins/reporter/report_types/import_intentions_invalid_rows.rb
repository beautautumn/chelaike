module Reporter::ReportTypes
  class ImportIntentionsInvalidRows
    attr_reader :user, :name

    def initialize(user, params)
      @user = user
      @name = "意向导入失败记录.xls"

      @import_task = params.fetch(:import_task)
      @records = params.fetch(:records)
    end

    def export
      file_path = "#{Dir.tmpdir}/#{user.id}_#{SecureRandom.hex}.xls"
      report = Spreadsheet::Workbook.new

      index = 0
      sheet = report.create_worksheet name: "意向导入失败记录"
      sheet.row(index).concat(::Intention::ImportService::HEADER_MAP.keys + ["理由"])

      @records.each do |record|
        index += 1
        sheet.row(index).concat(record)
      end

      report.write file_path

      upload(file_path)
    end

    def upload(file_path)
      oss_path = AliyunOss.put_assets(
        file_path, @name,
        forder: File.join(
          ENV.fetch("OSS_IMPORT_INTENTIONS_DIR"), SecureRandom.hex.to_s
        )
      )

      Util::File.delete(file_path)

      @import_task.update!(
        info: @import_task.info.merge(
          result_file: oss_path
        )
      )
    end
  end
end
