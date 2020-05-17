namespace :operation_record do
  desc "车币消息显示Fix"
  task fix_token_format: :environment do
    operation_records = OperationRecord.where(operation_record_type: :token_recharge)
    operation_records.each do |operation_record|
      info = operation_record.messages["info"]
      /你充值的(.*)车币已到账，当前剩余(.*)车币/ =~ info
      added = Regexp.last_match(1)
      balance = Regexp.last_match(2)
      info = "你充值的#{format("%.2f", added)}车币已到账，" \
             "当前剩余#{format("%.2f", balance)}车币"
      operation_record.messages["info"] = info
      operation_record.messages["token"] = format("%.2f", added)
      operation_record.save
    end
  end
end
