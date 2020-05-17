module V1
  class AllianceInvitationsController < ApplicationController
    before_action do
      authorize AllianceInvitation
    end
    before_action :find_alliance_invitation, except: :create

    def create
      return forbidden_error unless can_invited?

      service = AllianceInvitation::CreateService.new(
        params[:alliance_id], params[:company_ids], current_user
      ).execute

      if service.valid?
        render json: service.alliance,
               serializer: AllianceSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def agree
      authorize @alliance_invitation

      service = AllianceInvitation::AgreeService.new(
        @alliance_invitation, params[:alliance_id],
        current_user.company_id, current_user
      ).execute

      alliance_invitation = service.alliance_invitation
      if service.valid?
        render json: alliance_invitation,
               serializer: AllianceInvitationSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def disagree
      authorize @alliance_invitation

      service = AllianceInvitation::DisagreeService.new(
        @alliance_invitation, params[:alliance_id],
        current_user.company_id, current_user
      ).execute

      alliance_invitation = service.alliance_invitation
      if service.valid?
        render json: alliance_invitation,
               serializer: AllianceInvitationSerializer::Common,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    private

    def find_alliance_invitation
      @alliance_invitation = AllianceInvitation
                             .find_by!(alliance_id: params[:alliance_id],
                                       company_id: current_user.company_id,
                                       state: "pending")
    rescue ActiveRecord::RecordNotFound
      forbidden_error("操作已被处理或此联盟已解散")
    end

    def can_invited?
      Alliance.find(params[:alliance_id]).owner_id == current_user.company_id
    end
  end
end
