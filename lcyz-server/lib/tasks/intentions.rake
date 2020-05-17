namespace :intentions do
  desc "修复线上意向创建者类型错误"
  task fix_creator_type: :environment do
    Intention.where(
      creator_type: nil,
      alliance_company_id: nil
    ).update_all(creator_type: "User")
  end

  desc "初始化所有联盟意向状态，与意向状态同步"
  task init_alliance_state: :environment do
    Intention.where.not(alliance_company_id: nil).each do |intention|
      intention.update_columns(alliance_state: intention.state)
    end
  end

  desc "导出楚车联盟所有成员通过询最低价产生的意向条数"
  task chuche_alliance_intentions: :environment do
    alliance = Alliance.find(528) # 楚车联盟
    companies = alliance.companies
    companies.each_with_object([]) do |company, acc|
      intentions_count = company.intentions
                                .where.not(source_car_id: nil).count
      acc << { id: company.id, name: company.name,
               low_price_intentions_count: intentions_count }
    end
  end
end
