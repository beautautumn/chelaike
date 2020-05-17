namespace :alliance do
  desc "更新所有联盟请求的状态"
  task invitation_state: :environment do
    AllianceInvitation.find_each do |invitation|
      case invitation.state
      when "unprocessed"
        invitation.state = "pending"
      when "agreed"
        invitation.state = "accepted"
      when "disagreed"
        invitation.state = "refused"
      end

      invitation.save!
    end
  end

  desc "初始化所有公司的联盟昵称"
  task nickname: :environment do
    sql = <<-SQL.squish!
      UPDATE alliance_company_relationships
      SET nickname = c.name
      FROM companies c
        INNER JOIN alliance_company_relationships acr
          ON acr.company_id = c.id
      WHERE acr.nickname IS NULL
    SQL

    AllianceCompanyRelationship.connection.execute(sql)
  end

  desc "统计当天联盟成员入库情况并发消息"
  task cars_created_statistic: :environment do
    Alliance::CarsCreatedStatisticService.new.execute
  end
end
