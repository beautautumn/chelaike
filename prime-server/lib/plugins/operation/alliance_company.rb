module Operation
  class AllianceCompany
    class << self
      def init_company(alliance: nil, name: nil, companies: [])
        alliance_company = AllianceCompany::Company.create(name: name)
        alliance.update(alliance_company: alliance_company)

        # 创建联盟跟车商间关联
        companies.each do |company|
          alliance.alliance_company_relationships
                  .find_or_create_by(company_id: company.id)
        end

        # 把车商加入到联盟公司里
        alliance_company.add_companies(companies)

        # 搞一个超级管理员
        alliance_user = AllianceCompany::User.create!(
          name: "testmanager",
          company_id: alliance_company.id,
          username: "testmanager",
          password: "tiancar",
          phone: "13968024912"
        )

        service = AllianceCompanyService::AuthorityRole::Create.new(
          alliance_company.id, alliance_user.id)

        service.grant_manager_authorities
      end
    end
  end
end
