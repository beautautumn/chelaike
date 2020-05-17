module UserChat
  extend ActiveSupport::Concern

  included do
    has_many :chat_sessions, dependent: :destroy
    has_many :chat_groups, through: :chat_sessions, source: :target, source_type: "ChatGroup"
    has_many :conversations, dependent: :destroy
  end

  def group_chat_info(group)
    session = ChatSession.find_by!(
      user_id: id,
      target_id: group.id,
      target_type: "ChatGroup"
    )
    conversation = Conversation.find_or_create_by!(
      user_id: id,
      target_id:  group.id,
      conversation_type: "group"
    )

    {
      nickname: session.nickname,
      is_top: conversation.is_top,
      is_blocked: conversation.is_blocked,
      can_manege_user: chat_group_manager?(group),
      can_edit_name: chat_group_owner?(group),
      id: id,
      avatar: avatar
    }
  end

  def chat_group_manager?(group)
    case group.organize_type
    when "Company"
      id == group.owner_id
    when "Alliance"
      owned_company.try(:id) &&
        group.organize.company_joined?(owned_company.id)
    end
  end

  def chat_group_owner?(group)
    group.owner_id == id
  end
end
