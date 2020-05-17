class PriceTagTemplateCreateWorker
  include Sidekiq::Worker

  def perform(owner_id)
    owner = User.find(owner_id)

    PriceTagTemplate::CreateService.new(
      owner, "#{Rails.root}/lib/templates/price_tag/default.zip",
      "default", name: "默认模板"
    ).execute
  end
end
