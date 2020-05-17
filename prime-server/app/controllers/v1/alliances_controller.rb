module V1
  class AlliancesController < ApplicationController
    before_action except: [:update, :destroy, :companies, :chat_group] do
      authorize Alliance
    end
    before_action :find_alliance, except: [
      :index, :create, :cars, :companies, :car, :companies_except_me
    ]

    def index
      record_recent_keywords(:alliances)
      alliances = paginate current_user.company.alliances.includes(:owner)
                  .ransack(params[:query]).result.distinct

      render json: alliances,
             each_serializer: AllianceSerializer::Common,
             root: "data"
    end

    def update
      authorize @alliance

      @alliance.update(alliance_params)

      if @alliance.errors.empty?
        render json: @alliance, serializer: AllianceSerializer::Detail, root: "data"
      else
        validation_error(full_errors(@alliance))
      end
    end

    def create
      service = Alliance::CreateService.new(
        alliance_params.merge(owner_id: current_user.company_id),
        current_user, invited_companies)

      alliance = service.execute.alliance

      if service.valid?
        render json: alliance, serializer: AllianceSerializer::Detail, root: "data"
      else
        validation_error(service.errors)
      end
    end

    def show
      render json: @alliance,
             serializer: AllianceSerializer::Detail,
             root: "data",
             nicknames: nicknames
    end

    def destroy
      authorize @alliance

      @alliance.destroy

      if @alliance.errors.empty?
        render json: { data: {} }, scope: nil
      else
        validation_error(full_errors(@alliance))
      end
    end

    def companies
      render json: paginate(find_companies),
             each_serializer: CompanySerializer::Alliance,
             root: "data"
    end

    def companies_except_me
      render json: paginate(find_companies.where.not(id: current_user.company)),
             each_serializer: CompanySerializer::Alliance,
             root: "data"
    end

    def cars
      basic_params_validations
      param! :order_field, String,
             default: "acquired_at",
             in: %w(
               id show_price_cents age mileage name_pinyin acquired_at
             )

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

      record_recent_keywords(:allied_cars)
      data = paginate current_company_allied_cars
             .includes(:cover, :company)
             .state_in_stock_scope
             .ransack(params[:query]).result
             .order("#{params[:order_field]} #{order_by}")
             .order(:id)

      render json: data,
             each_serializer: CarSerializer::AllianceCarsList,
             root: "data"
    end

    def car
      authorize Alliance, :car?

      render json: current_company_allied_cars.find(params[:id]),
             serializer: CarSerializer::AllianceDetail,
             root: "data",
             include: "**"
    end

    def chat_group
      param! :state, String, in: %w(enable disable), required: true
      param! :type, String, in: %w(sale acquisition), required: true

      authorize @alliance, :master?

      ChatGroup::ManageService.new(
        params[:state],
        @alliance,
        params[:type]
      ).execute

      render json: { message: :ok }, scope: nil
    end

    private

    def find_alliance
      @alliance = Company.find(current_user.company_id).alliances.find(params[:id])
    end

    def alliance_params
      params.require(:alliance).permit(:name, :avatar, :note)
    end

    def invited_companies
      params[:invited_companies]
    end

    def company_params
      params.require(:company).permit(:id)
    end

    def current_company_allied_cars
      current_user.company.allied_cars
    end

    def nicknames
      Hash[@alliance.alliance_company_relationships.pluck(:company_id, :nickname)]
    end

    def find_companies
      authorize Alliance, :all_companies?

      alliance_ids = params.fetch(:query, {})["alliance_id_in"]
      if alliance_ids.present?
        Company.where(
          id: AllianceCompanyRelationship.where(
            alliance_id: alliance_ids
          ).select(:company_id).uniq
        )
      else
        current_user.company.allied_companies
      end
    end
  end
end
