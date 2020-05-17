class AllianceInvitation < ActiveRecord::Base
  class CreateService
    include ErrorCollector

    attr_reader :alliance

    def initialize(alliance_id, company_ids, user)
      @alliance_id = alliance_id
      @alliance = Alliance.find(@alliance_id)
      @company_ids = (company_ids || []) - [user.company_id]
      @user = user
    end

    def execute
      fallible @alliance

      begin
        AllianceInvitation.transaction do
          @company_ids.each do |company_id|
            @alliance_invitation = AllianceInvitation.pending.find_or_initialize_by(
              alliance_id: @alliance_id,
              company_id: company_id
            )

            fallible @alliance_invitation

            if @alliance.company_joined?(company_id)
              @alliance_invitation.errors.add("base", "该公司已加入联盟")
              return self
            end

            create_operation_record(company_id)
            @alliance_invitation.save! if @alliance_invitation.new_record?
          end
        end
      rescue
        @alliance
      end

      self
    end

    def create_operation_record(company_id)
      record = @alliance.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :alliance_invitation_created,
        messages: {
          state: "unprocessed",
          alliance_info: {
            avatar: @alliance.avatar,
            created_at: @alliance.created_at,
            note: @alliance.note
          },
          invited_company_ids: [company_id],
          alliance_id: @alliance.id,
          alliance_name: @alliance.name,
          company_name: @user.company.name,
          title: "联盟邀请",
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )

      @alliance_invitation.operation_record = record
    end
  end
end
