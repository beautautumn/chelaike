class DacWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(user_token, request_ip, url, params)
    DailyActiveService.record_info_to_db(user_token, request_ip, url, params)
  end
end
