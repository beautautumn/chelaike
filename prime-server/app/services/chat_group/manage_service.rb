class ChatGroup < ActiveRecord::Base
  class ManageService
    attr_accessor :action, :company, :type

    def initialize(state, organize, type)
      @state = state.to_s
      @organize = organize
      @type = type.to_s
    end

    def execute
      @chat_group = @organize.chat_groups.where(group_type: @type).first
      case @state
      when "enable".freeze
        @chat_group ? update : create
      when "disable".freeze
        update
      end
    end

    private

    def create
      @chat_group = ChatGroup.new
      @chat_group.organize = @organize
      @chat_group.name = group_name
      @chat_group.group_type = @type
      owner_id = group_owner_id
      @chat_group.owner_id = owner_id
      @chat_group.user_ids = group_user_ids
      @chat_group.save!
      Rongcloud::Group.create(
        @chat_group.user_ids,
        @chat_group.id,
        @chat_group.name
      )
      Rongcloud::Message.new(
        object_name: :text,
        from_user_id: owner_id,
        to_group_id: @chat_group.id,
        content: { content: "#{@chat_group.name}已创建" }
      ).group_send
    end

    def update
      @chat_group && @chat_group.update!(state: @state)
      @state == "enable" &&
        ChatGroup::UpdateService.new(@chat_group).join_user(alliance_updated_users)
    end

    def group_name
      case @type
      when "sale".freeze
        "#{@organize.name}销售群"
      when "acquisition".freeze
        "#{@organize.name}收购群"
      end
    end

    def group_owner_id
      case @chat_group.organize_type
      when "Company".freeze
        @organize.owner_id
      when "Alliance".freeze
        @organize.owner.owner_id
      end
    end

    # 1、公司群开启的时候，销售群（大群）是所有公司员工都在的，收购群（小群）是只有老板和收购师在；
    # 2、联盟群开启的时候，销售群是所有联盟公司内有有联盟管理权限的人都在，收购群是只有老板在

    def group_user_ids
      case @chat_group.organize_type
      when "Company".freeze
        company_group_user_ids
      when "Alliance".freeze
        alliance_group_user_id
      end
    end

    def company_group_user_ids
      case @type
      when "sale".freeze
        @organize.enabled_users.pluck(:id)
      when "acquisition".freeze
        ids = @organize.enabled_users.authorities_include("出售客户跟进").pluck(:id)
        ids << group_owner_id
        ids.uniq
      end
    end

    def alliance_group_user_id
      case @type
      when "sale".freeze
        @organize.enabled_users.pluck(:id)
      when "acquisition".freeze
        ids = @organize.enabled_users.authorities_any(*%w(联盟管理 车辆新增入库 车辆销售定价)).pluck(:id)
        ids << group_owner_id
        ids.uniq
      end
    end

    def alliance_updated_users
      ids = @organize.enabled_users.authorities_any("联盟管理").pluck(:id)
      ids << group_owner_id
      ids.uniq
    end
  end
end
