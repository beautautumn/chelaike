module V1
  class CarsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:qrcode]
    before_action :skip_authorization, only: [:qrcode]
    before_action except: [:create, :edit, :update, :destroy, :qrcode, :images_update, :onsale] do
      authorize Car
    end

    def index
      basic_params_validations
      param! :order_field, String,
             default: "id",
             in: %w(
               id stock_age_days show_price_cents age
               mileage name_pinyin acquired_at stock_out_at
             )

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"

      record_recent_keywords(:cars_in_stock)
      scope = Car.where(company_id: current_user.company_id)
                 .includes(:acquisition_transfer, :shop, :acquirer, :cover,
                           :car_reservation, :alliances, :all_alliances,
                           :prepare_record,
                           :alliance_stock_in_inventory)

      cars = paginate policy_scope(scope)
             .state_in_stock_scope
             .ransack(params[:query]).result
             .order("cars.#{params[:order_field]} #{order_by}")
             .order(id: :desc)

      render json: cars,
             each_serializer: CarSerializer::InStockList,
             root: "data"
    end

    def out_of_stock
      basic_params_validations
      param! :order_field, String,
             default: "stock_out_at",
             in: %w(id stock_out_at stock_age_days show_price_cents age mileage
                    name_pinyin)

      order_by = params[:order_by] == "asc" ? "ASC NULLS FIRST" : "DESC NULLS LAST"
      record_recent_keywords(:cars_out_of_stock)
      # eager load 会自动 left outer join stock_out_inventories
      cars = paginate policy_scope(current_company_cars.uniq)
             .state_out_of_stock_scope
             .includes(
               { stock_out_inventory: [:seller, :operator] },
               { alliance_stock_out_inventory: :alliance },
               :cover, :acquirer, :shop, { acquisition_transfer: :images }, :sale_transfer,
               :prepare_record
             ).ransack(params[:query]).result
             .order("cars.#{params[:order_field]} #{order_by}")
             .order("cars.id desc, cars.updated_at desc")

      render json: cars,
             each_serializer: CarSerializer::OutOfStockList,
             root: "data",
             include: "**"
    end

    def create
      car = Car.where(company_id: current_user.company_id).new(car_params)
      car.shop_id = current_user.shop_id unless car.shop_id.present?

      authorize car

      car = Car::CreateService
            .new(
              current_user, car, acquisition_transfer_params, publishers_params
            )
            .execute.car

      if car.errors.empty?
        render json: car,
               serializer: CarSerializer::Detail,
               root: "data", include: "**"
      else
        validation_error(full_errors(car))
      end
    rescue Car::CreateService::InvalidVinError => _
      validation_error(full_errors(car))
    end

    def show
      render json: current_company_cars.find(params[:id]),
             serializer: CarSerializer::Detail,
             root: "data", include: "**"
    end

    def viewed
      Car::ViewedCountService.add(params[:id])

      render nothing: true
    end

    def edit
      car = current_company_cars.find(params[:id])
      authorize car

      render json: car, serializer: CarSerializer::Edit, root: "data", include: "**"
    end

    def update
      car = current_company_cars.find(params[:id])
      authorize car

      service = Car::UpdateService.new(
        current_user, car, car_params, acquisition_transfer_params, publishers_params
      ).execute

      if service.valid?
        render json: service.car,
               serializer: CarSerializer::Detail,
               root: "data", include: "**"
      else
        validation_error(service.errors)
      end
    rescue Car::UpdateService::InvalidVinError => _
      validation_error(full_errors(car))
    end

    def destroy
      @car = Car.where(company_id: current_user.company_id).find(params[:id])
      authorize @car
      car = Car::DeleteService.new(current_user, @car).execute.car

      if car.errors.empty?
        car.notify_market_erp
        render json: car,
               serializer: CarSerializer::Common,
               root: "data"
      else
        validation_error(full_errors(car))
      end
    end

    def images_update
      car = current_company_cars.find(params[:car_id])
      authorize car

      service = Car::ImagesUpdateService.new(
        current_user, car, car_images_params, acquisition_transfer_images_params
      ).execute

      if service.valid?
        render json: service.car,
               serializer: CarSerializer::Detail,
               root: "data", include: "**"
      else
        validation_error(service.errors)
      end
    end

    def images_download
      param! :download_type,
             String,
             in: %w(car transfer),
             transform: :downcase,
             default: "transfer"

      car = current_company_cars.find(params[:car_id])

      urls = if params[:download_type] == "transfer"
               car.acquisition_transfer.images.map(&:url)
             elsif params[:image_type] == "water_mark"
               water_mark_urls(car)
             else
               car.images.map(&:url)
             end

      return render nothing: true, status: 204 if urls.length <= 0

      @download_service = Car::ImagesDownloadService.new(current_user, car, urls)
      zip_file, io = @download_service.download

      send_data(io.string, type: "application/zip", filename: zip_file)
    end

    def import
      param! :import_id, String, required: true
      job_key = "import_job_#{current_user.company_id}"

      return forbidden_error("任务正在执行中") if RedisClient.current.get(job_key).present?

      job_id = ImportWorker.perform_async(current_user.id, params[:import_id], job_key)

      RedisClient.current.set(fetch_import_job_key(current_user.company_id), job_id)

      render json: { data: { id: job_id } }, scope: nil
    end

    def import_status
      job_key = "import_job_#{current_user.company_id}"
      job_id = RedisClient.current.get(fetch_import_job_key(current_user.company_id))

      pct_complete = Sidekiq::Status.pct_complete(job_id)
      if RedisClient.current.get(job_key).present? && pct_complete.blank?
        pct_complete = 0
      end
      data = pct_complete.present? ? { pct_complete: pct_complete } : {}

      render json: { data: data }, scope: nil
    end

    def import_search
      companies = Spy.search(params[:company_name])

      render json: { data: companies }, scope: nil
    end

    def brands
      brands = model_scope.where("brand_name is not null")
                          .select(:brand_name).distinct
                          .select { |car| car.brand_name.present? }
                          .map do |car|
        pinyin = Util::Brand.to_pinyin(car.brand_name)
        next if pinyin.blank?

        {
          first_letter: pinyin.upcase,
          name: car.brand_name
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

    def acquirers
      param! :state_type, String, in: %w(in_stock out_of_stock)

      data = if current_user.can?("收购信息查看")
               scope = policy_scope(current_company_cars)
               if params[:state_type].present?
                 scope = scope.send("state_#{params[:state_type]}_scope")
               end

               acquirer_ids = scope.select(:acquirer_id).uniq

               User.where(id: acquirer_ids)
                   .ransack(params[:query]).result
                   .order(:first_letter, :name)
             else
               [current_user]
             end

      render json: data, each_serializer: UserSerializer::Mini, root: "data"
    end

    def sellers
      seller_id_column = "stock_out_inventories.seller_id"
      seller_ids = policy_scope(current_company_cars)
                   .state_out_of_stock_scope
                   .joins(:stock_out_inventory)
                   .select("DISTINCT #{seller_id_column}")
                   .where("#{seller_id_column} IS NOT NULL")
                   .group(seller_id_column.to_s)
                   .pluck(seller_id_column.to_s)

      users = User.where(id: seller_ids)
                  .ransack(params[:query]).result
                  .order(:first_letter, :name)

      render json: users, each_serializer: UserSerializer::Mini, root: "data"
    end

    def alliances
      render json: current_company_cars.find(params[:id]),
             serializer: CarSerializer::ShownAlliance,
             root: "data"
    end

    def update_alliances
      car = current_company_cars.find(params[:id])

      # 前端传过来的 alliances 有可能为 nil
      new_alliances = params[:alliances].nil? ? [] : params[:alliances].map(&:to_i)
      car.allowed_alliances = new_alliances

      render json: car,
             serializer: CarSerializer::ShownAlliance,
             root: "data"
    end

    def qrcode
      begin
        qrcode_url = fetch_wechat_qrcode
      rescue Wechat::Error::Unauthenticated
        content = Util::QRCode.new_official_url(params[:id])
        qrcode_url = qrcode_url(
          content: content
        )
      end
      # render json: { data: qrcode_url }, scope: nil
      redirect_to qrcode_url, status: 302
    end

    def meta_info
      car = Car.find(params[:id])

      response_data = {
        data: {
          state: car.state,
          allied: car.allied?(current_user),
          in_same_own_brand_alliance: car.in_same_own_brand_alliance?(current_user)
        }
      }
      render json: response_data, scope: nil
    end

    def similar
      car = Car.find(params[:id])

      cars = current_company_cars.state_in_stock_scope
                                 .where.not(id: car.id)
                                 .similar(car.brand_name, car.series_name, car.show_price_cents)
                                 .limit(4)

      render json: cars,
             each_serializer: CarSerializer::Basic,
             root: "data"
    end

    def alliance_similar
      car = Car.find(params[:id])

      cars = current_company.allied_cars
                            .state_in_stock_scope
                            .where.not(company_id: car.company_id)
                            .similar(car.brand_name, car.series_name, car.show_price_cents)
                            .includes(:company).limit(8)

      render json: cars,
             each_serializer: CarSerializer::AllianceCarsList,
             root: "data"
    end

    def multi_images_share
      car = Car.find(params[:id])
      service = Car::MultiImageShareService.new(current_user, car)
      result = service.execute

      render json: { data: result }, scope: nil
    end

    # 根据car_id得到分享出去的微店地址
    def shared_url
      car = Car.find(params[:id])
      result = Car::WeshopService.new(car).shared_detail_url(current_user.id)

      render json: { data: result }, scope: nil
    end

    # app传过来过滤条件，接口返回新官网的车辆列表地址
    def shared_car_list
      query_params = params[:query]

      result = Car::WeshopService.new.cars_list_url(current_user, query_params)

      render json: { data: result }, scope: nil
    end

    # 一辆车在入库前，检查vin码是否已存在
    def check_vin
      car = current_user.company.cars.state_in_stock_scope.where(vin: params[:vin])
      render json: { data: { status: car.blank? } }, scope: nil
    end

    # 控制车辆是否特卖
    def onsale
      param! :is_onsale, :boolean, default: false

      car = current_company_cars.find(params[:id])
      authorize car

      if params[:is_onsale]
        car.update!(
          is_onsale: true,
          onsale_price_wan: params[:onsale_price_wan],
          onsale_description: params[:onsale_description]
        )

      else
        car.update!(
          is_onsale: false,
          onsale_price_wan: nil
        )
      end

      render json: car,
             serializer: CarSerializer::Detail,
             root: "data", include: "**"
    end

    def info_by_vin
      vin = params[:vin]

      result = car_info_by_vin(vin)

      render json: { data: result }, scope: nil
    end

    private

    def water_mark_urls(car)
      alliance_company = car.company.alliance_company
      return car.images.map(&:url) if alliance_company.blank?
      car.images.map do |image|
        image.with_water_mark(
          alliance_company.water_mark_position,
          alliance_company.water_mark
        )
      end
    end

    def fetch_import_job_key(company_id)
      "fetch_import_job_key_#{company_id}"
    end

    def fetch_wechat_qrcode
      if wechat_valid?(current_company)
        fetch_and_cache_qrcode(current_company)
      elsif wechat_valid?(current_alliance_company)
        fetch_and_cache_qrcode(current_alliance_company)
      else
        # 微信授权取消通知有延迟，所以需要注意捕获未认证的异常
        raise Wechat::Error::Unauthenticated
      end
    end

    def current_alliance_company
      current_company.alliance_company
    end

    def wechat_valid?(company)
      company.try(:wechat_app).try(:state).try(:enabled?).present?
    end

    def current_company
      @company ||= Car.find(params[:id]).company
    end

    def fetch_and_cache_qrcode(company)
      cache_key = "wechat:qrcode:car:#{params[:id]}"
      Rails.cache.fetch(cache_key) do
        scene = Wechat::Reducer.scan_scene(Wechat::Reducer::PRICE_TAG_SCAN, params[:id])
        Wechat::Mp::Qrcode.generate(company.wechat_app.app_id, scene)
      end
    end

    def model_scope
      param! :state_type, String, in: %w(in_stock out_of_stock)

      scope = if params[:is_allied]
                current_user.company.allied_cars
              else
                current_user.company.cars
              end

      scope = scope.send("state_#{params[:state_type]}_scope") if params[:state_type].present?

      scope
    end

    def car_images_params
      handle_images_sort(params[:car])
      params.require(:car).permit(
        images_attributes: [:id, :url, :location, :sort, :is_cover, :_destroy]
      )
    end

    def acquisition_transfer_images_params
      return {} unless params[:acquisition_transfer].present?
      handle_images_sort(params[:acquisition_transfer])

      params.require(:acquisition_transfer).permit(
        images_attributes: [
          :id, :url, :location, :sort, :is_cover, :_destroy
        ]
      )
    end

    def car_params
      handle_images_sort(params[:car])
      params.require(:car).permit(
        { attachments: [] }, :sellable, :name, :is_special_offer, :fee_detail,
        :acquirer_id, :acquired_at, :channel_id, :acquisition_type, :shop_id,
        :acquisition_price_wan, :stock_number, :vin, :state, :state_note,
        :brand_name, :manufacturer_name, :series_name, :style_name, :car_type,
        :door_count, :displacement, :is_turbo_charger, :fuel_type, :transmission,
        :exterior_color, :interior_color, :mileage, :red_stock_warning_days,
        :emission_standard, :license_info, :licensed_at, :manufactured_at, :level,
        :show_price_wan, :online_price_wan, :sales_minimun_price_wan, :mileage_in_fact,
        :manager_price_wan, :alliance_minimun_price_wan, :new_car_guide_price_wan,
        :new_car_additional_price_wan, :new_car_discount, :new_car_final_price_wan,
        :interior_note, :star_rating, :warranty_id, :warranty_fee_yuan, :is_fixed_price,
        :allowed_mortgage, :mortgage_note, :selling_point, :maintain_mileage,
        :has_maintain_history, :new_car_warranty, :yellow_stock_warning_days,
        :consignor_name, :consignor_phone, :consignor_price_wan, :configuration_note,
        { images_attributes: [:id, :url, :location, :sort, :is_cover, :_destroy] },
        cooperation_company_relationships_attributes: [
          :id, :cooperation_company_id, :cooperation_price_wan, :_destroy
        ]
      ).tap do |white_listed|
        manufacturer_configuration = params[:car][:manufacturer_configuration]

        if manufacturer_configuration
          white_listed[:manufacturer_configuration] = manufacturer_configuration
        end
      end
    end

    def publishers_params
      return {} unless params[:publishers]
      params.require(:publishers).permit(che168: [:syncable, :seller_id])
    end

    def acquisition_transfer_params
      return {} unless params[:acquisition_transfer].present?
      handle_images_sort(params[:acquisition_transfer])

      params.require(:acquisition_transfer).permit(
        :key_count, :compulsory_insurance_end_at, :commercial_insurance_end_at,
        :commercial_insurance_amount_yuan, :annual_inspection_end_at,
        :compulsory_insurance, :commercial_insurance, :current_plate_number,
        images_attributes: [
          :id, :url, :location, :sort, :is_cover, :_destroy
        ]
      )
    end

    def handle_images_sort(origin_hash)
      images_arr = origin_hash.fetch(:images_attributes, [])
      return if images_arr.blank?
      result = images_arr.each_with_index do |image_hash, index|
        image_hash[:sort] = index
      end

      origin_hash[:images_attributes] = result
    end

    def current_company_cars
      Car.where(company_id: current_user.company_id)
    end

    def car_info_by_vin(vin)
      che3bai_service = Che3bai::LoanService.new
      che3bai_service.megatron_styles_by_vin(vin)
      # {"status"=>"1", "modelInfo"=>[{"series_group_name"=>"进口凯迪拉克", "color"=>"", "model_liter"=>"3.0L", "model_year"=>2015, "brand_name"=>"凯迪拉克", "model_id"=>24644, "brand_id"=>73, "series_id"=>760, "model_name"=>"2015款 凯迪拉克SRX 3.0L 舒适型", "model_price"=>39.98, "model_emission_standard"=>"欧4", "model_gear"=>"自动", "series_name"=>"凯迪拉克SRX", "min_reg_year"=>2015, "max_reg_year"=>2018, "ext_model_id"=>0}]}
    end
  end
end
