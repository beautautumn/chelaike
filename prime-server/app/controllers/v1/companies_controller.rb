module V1
  class CompaniesController < ApplicationController
    before_action do
      authorize Company
    end

    before_action :find_company, expect: :index

    def index
      companies = paginate Company.all
                  .ransack(params[:query]).result
      render json: companies,
             each_serializer: CompanySerializer::Alliance,
             root: "data"
    end

    def customers
      render json: current_user.company.customers.follow_up,
             each_serializer: CustomerSerializer::Common,
             root: "data"
    end

    def own_brand_alliances
      render json: @company.alliances.own_brand,
             each_serializer: AllianceSerializer::Basic,
             root: "data"
    end

    def automated_stock_number
      @company.update(automated_stock_number_params)
      if @company.errors.empty?
        render json: @company,
               serializer: CompanySerializer::AutomatedStockNumber,
               root: "data"
      else
        validation_error(full_errors(@company))
      end
    end

    def financial_configuration
      render json: @company,
             serializer: CompanySerializer::FinancialConfiguration,
             root: "data"
    end

    def update_financial_configuration
      @company.update(financial_configuration_params)
      if @company.errors.empty?
        render json: @company,
               serializer: CompanySerializer::FinancialConfiguration,
               root: "data"
      else
        validation_error(full_errors(@company))
      end
    end

    def unified_management
      @company.update(unified_management_params)

      if @company.errors.empty?
        render json: @company,
               serializer: CompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(@company))
      end
    end

    def show
      render json: @company,
             serializer: CompanySerializer::Common,
             root: "data"
    end

    def update
      @company.update(company_params)

      if @company.errors.empty?
        render json: @company,
               serializer: CompanySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(@company))
      end
    end

    def official_website_url
      app_version = request.headers["AutobotsMobileAppVersion"] || "0"

      website_url = @company.official_website(app_version)
      url = "#{website_url}?seller_id=#{current_user.id}" if website_url.present?
      response_data = {
        data: {
          id: @company.id,
          official_website_url: url
        }
      }

      render json: response_data, scope: nil
    end

    # 可能没被用到
    def chat_group
      param! :state, String, in: %w(enable disable), required: true
      param! :type, String, in: %w(sale acquisition), required: true

      ChatGroup::ManageService.new(
        params[:state],
        @company,
        params[:type]
      ).execute

      render json: { message: :ok }, scope: nil
    end

    def shops
      render json: @company.shops,
             each_serializer: ShopSerializer::Common,
             root: "data"
    end

    def check_accredited
      if @company.accredited_records.blank?
        contact_phone = EasyLoan::Setting.first.phone
        error_message = "贵公司尚未申请库融授信，请联系车来客客服！联系电话：#{contact_phone}"
        render json: { data: { state: false, message: error_message, phone: contact_phone } },
               scope: nil
      else
        render json: { data: { state: true } }, scope: nil
      end
    end

    # 得到某家公司所有分店的城市
    def cities_name
      names = @company.cities_name

      render json: { data: names }
    end

    private

    def find_company
      @company = current_user.company
    end

    def automated_stock_number_params
      params.require(:company).permit(
        settings: [
          :automated_stock_number,
          :automated_stock_number_prefix,
          :automated_stock_number_start,
          :stock_number_by_vin
        ]
      )
    end

    def financial_configuration_params
      params.require(:company).permit(
        financial_configuration: [
          :fund_rate,
          :fund_total_wan,
          :fund_by_company,
          :rent_by,
          :rent,
          :area,
          :gearing
        ]
      )
    end

    def company_params
      params.require(:company).permit(
        :name, :contact, :contact_mobile, :acquisition_mobile,
        :sale_mobile, :logo, :province, :city, :district, :street,
        :avatar, :note, { banners: [] }, :qrcode, :facade
      ).tap do |hash|
        hash[:banners] = [] if hash[:banners].blank?
      end
    end

    def unified_management_params
      params.require(:company).permit(settings: [:unified_management])
    end
  end
end
