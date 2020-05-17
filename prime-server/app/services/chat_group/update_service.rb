class ChatGroup < ActiveRecord::Base
  class UpdateService
    attr_accessor :user_group, :chat_group

    def initialize(chat_group)
      @chat_group = chat_group
    end

    def refresh_name(name)
      @chat_group.update!(name: name)
      Rongcloud::Group.refresh(
        @chat_group.id,
        name
      )
    end

    def join_user(user_ids)
      old = @chat_group.user_ids
      new_user_ids = old + user_ids
      @chat_group.user_ids = new_user_ids.uniq
      rong_join(user_ids)
    end

    def quit_user(user_ids)
      old = @chat_group.user_ids
      new_user_ids = old - user_ids
      @chat_group.user_ids = new_user_ids.uniq
      rong_quit(user_ids)
    end

    private

    def rong_join(add)
      Rongcloud::Group.join(
        add,
        @chat_group.id,
        @chat_group.name
      )
    end

    def rong_quit(remove)
      Rongcloud::Group.quit(
        remove,
        @chat_group.id
      )
    end
  end
end
