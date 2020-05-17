class ChatGroupPolicy < ApplicationPolicy
  def edit_name?
    owner?
  end

  def join_user?
    manage_user?
  end

  def quit_user?
    manage_user?
  end

  private

  def manage_user?
    user.chat_group_manager?(record)
  end

  def owner?
    record.owner_id == user.id
  end
end
