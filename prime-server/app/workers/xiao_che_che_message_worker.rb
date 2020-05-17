class XiaoCheCheMessageWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(to_user_ids, message_text)
    XiaoCheCheService.publish_message(to_user_ids, message_text)
  end
end
