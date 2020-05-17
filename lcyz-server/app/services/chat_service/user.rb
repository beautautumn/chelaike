module ChatService
  class User
    attr_accessor :user, :rc_user, :platform

    def initialize(user, platform = :default)
      @user = user
      @platform = platform

      @rc_user = Rongcloud::User.new(
        id: @user.rongcloud_id,
        name: user.username,
        portrait_uri: user.avatar
      )
    end

    def rc_token
      token = @user.rc_token
      return token if token.present?

      token = ""
      Rongcloud::Configure.load_config(@platform) do
        token = @rc_user.token
      end
      @user.update!(rc_token: token)
      token
    end

    def refresh
      Rongcloud::Configure.load_config(@platform) do
        @rc_user.refresh(
          name: @user.username,
          portrait_uri: @user.avatar
        )
      end
    end

    def avaliable_users
      company = user.company
      alliance_ids = company.alliances.pluck(:alliance_id)

      company_ids = Company.select(:id)
                           .includes(:alliance_company_relationships)
                           .where("alliance_company_relationships.alliance_id in (?)", alliance_ids)
                           .references(:alliance_company_relationships)

      ::User.where(
        "company_id in (?)", company_ids.map(&:id)
      ).enabled
    end

    # 所有的状态为 enabled 的用户
    def all_users
      ::User.enabled
    end

    def quit_all_groups
      @user.chat_groups.each do |group|
        service = ChatGroup::UpdateService.new(group)
        service.quit_user([@user.id])
      end
    end

    def same_alliance_users
      avaliable_users.where.not(company_id: @user.company_id)
    end
  end
end
