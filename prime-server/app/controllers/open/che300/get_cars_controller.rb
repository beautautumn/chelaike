module Open
  module Che300
    class GetCarsController < Open::ApplicationController
      skip_before_action :authenticate_app!
      before_action :authenticate_che300, :find_cars

      def index
        page_size = params[:page_size] ? params[:page_size].to_i : Kaminari.config.default_per_page
        paged_cars = @cars.page(params[:page_index]).per(page_size)

        RedisClient.current.set("che300_last_car_id", paged_cars.last.id) unless paged_cars.blank?

        serialized_cars = ActiveModelSerializers::SerializableResource.new(
          paged_cars,
          each_serializer: CarSerializer::Che300List
        )

        render json: {
          status_code: 0,
          status_msg: "成功",
          data: {
            page_index: params[:page_index],
            page_size: page_size,
            total_page: paged_cars.total_pages,
            items: serialized_cars.as_json[:cars]
          }
        }
      end

      private

      def authenticate_che300
        unless params[:app_id] == ENV["CHE_300_GET_CARS_TOKEN"]
          return render json: {
            status_code: -1,
            status_msg: "Token无效"
          }
        end
      end

      def find_cars
        start_date = if params[:start_date]
                       Time.zone.parse(params[:start_date])
                     else
                       Time.zone.today
                     end
        cars = Car.where("created_at > ?", start_date).order(:id)
        # 增量数据
        @cars = if params[:is_all] == 0
                  # 上次获取的最后一条, 可能为空
                  cars.where("id > ?", RedisClient.current.get("che300_last_car_id"))
                else
                  cars
                end
      end
    end
  end
end
