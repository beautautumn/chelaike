class ChatGroupUsersWorker
  include Sidekiq::Worker

  def perform(chat_group_id, user_ids, action)
    chat_group = ChatGroup.find(chat_group_id)
    service = ChatGroup::UpdateService.new(chat_group)

    case action
    when "join_users"
      join_users(service, user_ids)
    when "quit_users"
      quit_users(service, user_ids)
    end
  end

  def join_users(service, user_ids)
    service.join_user(user_ids)
  end

  def quit_users(service, user_ids)
    service.quit_user(user_ids)
  end
end
