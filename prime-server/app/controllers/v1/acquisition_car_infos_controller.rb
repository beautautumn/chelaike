module V1
  class AcquisitionCarInfosController < ApplicationController
    before_action :find_acquisition_car_info,
                  except: [:create, :index,
                           :levels, :brands,
                           :series]
    before_action :skip_authorization

    def index
      basic_params_validations

      infos = infos_scope.ransack(params[:query]).result

      render json: paginate(infos),
             each_serializer: AcquisitionCarInfoSerializer::Info,
             with_intention: true,
             root: "data"
    end

    # 得到所有收车评估里的品牌
    def brands
      brands = model_scope.where("brand_name is not null")
                          .select(:brand_name).distinct
                          .select { |info| info.brand_name.present? }
                          .map do |info|
        pinyin = Util::Brand.to_pinyin(info.brand_name)
        next if pinyin.blank?

        {
          first_letter: pinyin.upcase,
          name: info.brand_name
        }
      end

      render json: { data: brands.compact.sort_by! { |e| e[:first_letter] } }, scope: nil
    end

    def series
      company_series = model_scope.where("series_name is not null")
                                  .select(:series_name).distinct
                                  .map(&:series_name)

      series = Megatron.series(params[:brand][:name])

      series = series["data"].map do |s|
        {
          manufacturer_name: s["manufacturer_name"],
          series: s["series"].select do |e|
            company_series.include?(e["name"])
          end
        }
      end
      series.reject! do |s|
        s[:series].empty?
      end

      render json: { data: series }, scope: nil
    end

    def levels
      scope = infos_scope.where.not(intention_level_name: [nil, ""]).uniq
      render json: { data: scope.map(&:intention_level_name) }, scope: nil
    end

    def create
      service = AcquisitionCarInfoService::Create.new(
        current_user, acquisition_car_params
      ).execute(
        chat_id: params[:chat_id],
        chat_type: params[:chat_type]
      )

      if service.valid?
        render json: service.info,
               serializer: AcquisitionCarInfoSerializer::Info,
               root: "data"
      else
        validation_error(service.errors)
      end
    end

    def update
      authorize @info

      @info.update!(acquisition_car_params)
      render json: @info,
             serializer: AcquisitionCarInfoSerializer::Info,
             root: "data"
    end

    def show
      info = AcquisitionCarInfo.includes(comments: [:company, :commenter]).find(params[:id])
      render json: info,
             serializer: AcquisitionCarInfoSerializer::Info,
             cooperates: true,
             root: "data"
    end

    def assign
      authorize @info
      service = AcquisitionCarInfoService::Assign.new(current_user, @info)
      service.assign_to(params[:acquirer_id])

      render json: @info,
             serializer: AcquisitionCarInfoSerializer::Info,
             cooperates: true,
             root: "data"
    end

    # 收车信息转发
    def forwarding
      chat = params[:chat]
      type = chat[:type]

      chat_type = {
        group: "ChatGroup",
        private: "User"
      }.fetch(type.to_sym, "User")

      @info.publish_records.create!(
        chatable_id: chat[:id], chatable_type: chat_type
      )

      render json: { data: "OK" },
             scope: nil
    end

    def confirm_acquisition
      service = AcquisitionCarInfoService::Confirmation.new(
        current_user, @info
      )

      result = service.create(acquisition_confirmation_params)

      if result.valid?
        render json: result.confirmation,
               serializer: AcquisitionCarInfoSerializer::Confirmation,
               car_id: result.car.id,
               root: "data"
      else
        validation_error(result.errors)
      end
    end

    private

    def model_scope
      if current_user.can?("出售客户管理")
        AcquisitionCarInfo.where(company_id: current_user.company_id)
      else
        current_user.acquisition_car_infos
      end
    end

    def infos_scope
      scope = if current_user.can?("全部出售客户管理")
                AcquisitionCarInfo.includes(:company, :acquirer, comments: [:company, :commenter])
                                  .where(company_id: current_user.company_id)
              elsif current_user.can?("出售客户管理")
                scope = AcquisitionCarInfo.includes(
                  :company, :acquirer,
                  comments: [:company, :commenter])
                scope.where(company_id: current_user.company_id,
                            acquirer_id: User.subordinate_users_with_self(current_user.id))
              else
                current_user.acquisition_car_infos.includes(
                  :company, :acquirer, comments: [:company, :commenter]
                )
              end
      scope.order(created_at: :desc)
    end

    def acquisition_car_params
      params[:acquisition_car_info][:images] ||= []
      params[:acquisition_car_info][:manufacturer_configuration] ||= []
      params[:acquisition_car_info][:note_audios] ||= []

      params.require(:acquisition_car_info).permit(
        :brand_name, :series_name, :style_name,
        :key_count, :licensed_at, :license_info,
        :new_car_guide_price_wan, :new_car_final_price_wan, :manufactured_at,
        :mileage, :exterior_color, :interior_color, :displacement,
        :prepare_estimated_yuan, :valuation_wan, :note_text,
        { images: [:url, :type, :is_cover] },
        :is_turbo_charger,
        { note_audios: [:url, :duration] }, :configuration_note
      ).tap do |white_listed|
        car_info_params = params[:acquisition_car_info]

        attrs = [:manufacturer_configuration, :procedure_items, :owner_info]
        attrs.each do |key|
          value = car_info_params.fetch(key, nil)
          white_listed[key] = value if value
        end
      end
    end

    def acquisition_confirmation_params
      params.require(:acquisition_confirmation).permit(
        :acquisition_price_wan, :acquired_at, { cooperate_companies: [] },
        :company_id, :shop_id, :alliance_id
      )
    end

    def find_acquisition_car_info
      @info = AcquisitionCarInfo.find(params[:id])
    end
  end
end
