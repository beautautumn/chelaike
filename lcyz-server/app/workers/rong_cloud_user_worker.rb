class RongCloudUserWorker
  include Sidekiq::Worker

  def perform(action, user_id)
    user = User.with_deleted.find(user_id)
    service = ChatService::User.new(user)
    service.send(action)
  end
end
