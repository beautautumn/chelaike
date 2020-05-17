module Dashboard
  class AlliancesController < ApplicationController
    before_action do
      authorize :dashboard_alliance
    end

    def index
      #return @alliances = Alliance.none.page(0) unless search?

      @alliances = Alliance.includes(:owner).order(:id)
                           .ransack(params[:q])
                           .result
                           .page(params[:page])
                           .per(20)
      @counter = Alliance.ransack(params[:q]).result.count
    end

    def honesty_tag
      identity_action(:honesty_tag)

      redirect_to alliances_path
    end

    def active_tag
      identity_action(:active_tag)

      redirect_to alliances_path
    end

    def own_brand_tag
      identity_action(:own_brand_tag)

      redirect_to alliances_path
    end

    private

    def identity_action(action_type)
      ActiveRecord::Base.connection.transaction do
        alliance = Alliance.find(params[:alliance_id])
        alliance.update(action_type => params.key?(:active))

        type = params.key?(:active) ? "enable_alliance_#{action_type}" : "disable_alliance_#{action_type}"

        record(alliance, type)
      end
    end

    def record(alliance, type)
      current_staff.operation_records.create(
        operation_type: type,
        content: {
          alliance_id: alliance.id,
          alliance_name: alliance.name,
          company_id: alliance.owner_id,
          company_name: alliance.owner.try(:name)
        }
      )
    end
  end
end
