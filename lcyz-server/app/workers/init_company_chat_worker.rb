class InitCompanyChatWorker
  include Sidekiq::Worker

  def perform(company_id)
    company = Company.find(company_id)
    init_chat_groups(company)
  end

  def init_chat_groups(company)
    # %w(sale acquisition).each do |chat_type|
    chat_type = "sale"
    ChatGroup::ManageService.new(
      "enable",
      company,
      chat_type
    ).execute
    # end
  end
end
