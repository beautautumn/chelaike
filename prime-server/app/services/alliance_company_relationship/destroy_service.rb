class AllianceCompanyRelationship < ActiveRecord::Base
  class DestroyService
    attr_reader :relationship

    def initialize(relationship, alliance, company_id, user)
      @relationship = relationship
      @alliance = alliance
      @company_id = company_id
      @user = user

      if user.company_id == alliance.owner_id
        @operation_type = :alliance_relationship_deleted
        @message_title = "移出联盟"
      else
        @operation_type = :alliance_relationship_quit
        @message_title = "退出联盟"
      end
    end

    def execute
      AllianceCompanyRelationship.transaction do
        @relationship.destroy
        Company.find(@company_id).update!(alliance_company_id: nil)
        create_operation_record
        quit_company_users
      end

      self
    end

    def create_operation_record
      @alliance.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: @operation_type,
        messages: {
          alliance_id: @alliance.id,
          company_name: @user.company.name,
          owner_id: @alliance.owner.id,
          company_id: @relationship.company_id,
          title: @message_title,
          alliance_name: @alliance.name,
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end

    private

    # 把这家公司里的人从联盟聊天里去掉
    def quit_company_users
      %w(sale acquisition).each do |chat_type|
        chat_group = @alliance.chat_groups.where(group_type: chat_type).first
        if chat_group
          user_ids = company_existing_users(chat_group)
          ChatGroupUsersWorker.perform_async(chat_group.id, user_ids, "quit_users")
        end
      end
    end

    def company_existing_users(chat_group)
      company = Company.find(@company_id)
      chat_group.users.where(id: company.users.pluck(:id)).pluck(:id)
    end
  end
end
