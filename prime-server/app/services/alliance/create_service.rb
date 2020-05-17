class Alliance < ActiveRecord::Base
  class CreateService
    include ErrorCollector

    attr_reader :alliance

    def initialize(params, user, invited_company_ids)
      @alliance_params = params
      @invited_company_ids = (invited_company_ids || []) - [user.company_id]
      @user = user
    end

    def execute
      @alliance = Alliance.new(@alliance_params)

      begin
        Alliance.transaction do
          @alliance.save!
          @relationship = @alliance.alliance_company_relationships
                                   .new(company: @user.company)
          @relationship.save!
          @operation_id = create_operation_record.id
          create_invitation(@alliance.id, @invited_company_ids)
        end
      rescue
        @alliance
      end

      fallible @alliance, @relationship

      self
    end

    private

    def create_invitation(alliance_id, invited_company_ids)
      now = Time.zone.now.to_s(:db)

      operation = invited_company_ids.inject("") do |sql, company_id|
        sql << <<-SQL
          INSERT INTO #{AllianceInvitation.table_name}
            (alliance_id, company_id, operation_record_id, state, created_at, updated_at)
            VALUES
            ('#{alliance_id}', '#{company_id}', '#{@operation_id}',
            'pending', '#{now}', '#{now}');
        SQL
      end.squish!

      AllianceInvitation.connection.execute(operation)
    end

    def create_operation_record
      @alliance.operation_records.create!(
        user: @user,
        company_id: @user.company_id,
        operation_record_type: :alliance_invitation_created,
        messages: {
          state: "unprocessed",
          alliance_info: {
            id: @alliance.id,
            name: @alliance.name,
            avatar: @alliance.avatar,
            created_at: @alliance.created_at,
            note: @alliance.note
          },
          invited_company_ids: @invited_company_ids,
          alliance_id: @alliance.id,
          alliance_name: @alliance.name,
          company_name: @user.company.name,
          title: "联盟邀请",
          user_name: @user.name
        },
        user_passport: @user.passport.to_h
      )
    end
  end
end
