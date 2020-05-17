class AllianceInvitation < ActiveRecord::Base
  class DisagreeService
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
          disagree_invitation
          create_operation_record
        end
      rescue AASM::InvalidTransition
        @alliance_invitation.errors.add(:base, "操作已被处理或此联盟已解散")
      end

      self
    end

    private

    def disagree_invitation
      @alliance_invitation.reject(@user.id)

      @operation_record.messages[:state] = "disagreed"
      @operation_record.save!
    end

    def create_operation_record
      @alliance.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :alliance_invitation_disagreed,
        messages: {
          alliance_id: @alliance.id,
          alliance_name: @alliance.name,
          company_id: @alliance.owner.id,
          company_name: @user.company.name,
          title: "拒绝邀请",
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
