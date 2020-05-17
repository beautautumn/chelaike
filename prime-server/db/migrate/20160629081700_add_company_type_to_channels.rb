class AddCompanyTypeToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :company_type, :string, comment: "渠道所属公司多态"

    Channel.update_all(company_type: "Company")

    # 把现在联盟公司里的渠道转到channels表里
    companies = AllianceCompany::Company.all
    companies.each do |company|
      channels = AllianceCompany::Channel.where(company_id: company.id)
      channels.each do |channel|
        Channel.create(company: company, name: channel.name, note: channel.note)
      end
    end
  end
end
