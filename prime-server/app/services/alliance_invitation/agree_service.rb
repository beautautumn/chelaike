class AllianceInvitation < ActiveRecord::Base
  class AgreeService
    include ErrorCollector

    attr_reader :alliance_invitation

    def initialize(alliance_invitation, alliance_id, company_id, user)
      @alliance_invitation = alliance_invitation
      @alliance = Alliance.find(alliance_id)
      @alliance_id = alliance_id
      @company_id = company_id
      @user = user
      @operation_record = @alliance_invitation.operation_record
    end

    def execute
      fallible @alliance_invitation, @operation_record

      begin
        AllianceInvitation.transaction do
          accept_invitation
          process_chat_groups
          create_operation_record
        end
      rescue AASM::InvalidTransition
        @alliance_invitation.errors.add(:base, "操作已被处理或此联盟已解散")
      end

      self
    end

    private

    def accept_invitation
      @alliance_invitation.accept(@user.id)

      @operation_record.messages[:state] = "agreed"
      @operation_record.save!
    end

    def process_chat_groups
      %w(sale acquisition).each do |chat_type|
        chat_group = @alliance.chat_groups.where(group_type: chat_type).first
        if chat_group
          user_ids = company_alliance_user_ids(chat_type)
          ChatGroupUsersWorker.perform_async(chat_group.id, user_ids, "join_users")
        end
      end
    end

    def company_alliance_user_ids(chat_type)
      company = Company.find(@company_id)
      case chat_type.to_s
      when "sale".freeze
        company.enabled_users.pluck(:id)
      when "acquisition".freeze
        ids = [company.owner_id]
        ids.uniq
      end
    end

    def create_operation_record
      @alliance.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :alliance_invitation_agreed,
        messages: {
          alliance_id: @alliance.id,
          company_id: @user.company.id,
          company_name: @user.company.name,
          title: "同意邀请",
          alliance_name: @alliance.name,
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
