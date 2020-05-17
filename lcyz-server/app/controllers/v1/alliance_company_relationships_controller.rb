module V1
  class AllianceCompanyRelationshipsController < ApplicationController
    before_action do
      authorize AllianceCompanyRelationship
    end
    before_action :find_alliance
    before_action :find_alliance_company_relationship, except: :create

    def create
      relationship = @alliance.alliance_company_relationships.create(
        company_id: company_params[:id], alliance_id: params[:id])

      if relationship.errors.empty?
        render json: @alliance, serializer: AllianceSerializer::Common, root: "data"
      else
        validation_error(full_errors(relationship))
      end
    end

    def update
      @relationship.update(alliance_company_relationship_params)

      if @relationship.errors.empty?
        render json: { completed: true }, scope: nil
      else
        validation_error(full_errors(@relationship))
      end
    end

    def destroy
      return forbidden_error unless can_destroy?

      relationship = AllianceCompanyRelationship::DestroyService.new(
        @relationship, @alliance, params[:company_id], current_user
      ).execute.relationship

      if relationship.errors.empty?
        render json: @alliance, serializer: AllianceSerializer::Common, root: "data"
      else
        validation_error(full_errors(relationship))
      end
    end

    private

    def alliance_company_relationship_params
      params.require(:company).permit(:nickname)
    end

    def find_alliance
      @alliance = Company.find(current_user.company_id).alliances.find(params[:id])
    end

    def find_alliance_company_relationship
      company_id = params[:company_id] || current_user.company_id

      @relationship = @alliance.alliance_company_relationships
                               .find_by!(company_id: company_id)
    end

    def can_destroy?
      current_user.company_id == @alliance.owner_id ||
        current_user.company_id == params[:company_id].to_i
    end
  end
end
