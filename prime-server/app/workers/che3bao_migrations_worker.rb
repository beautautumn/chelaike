class Che3baoMigrationsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :migration

  def perform(corp_id)
    host = "http://customer_service.lina.che3bao.com"
    url = "#{host}/che3bao/corps/#{corp_id}/migration_notification"

    begin
      Che3bao::MigrationService.new(corp_id).execute
      Util::Request.put(url)
    rescue
      Util::Request.put(url, state: "failed")
    end
  end
end
