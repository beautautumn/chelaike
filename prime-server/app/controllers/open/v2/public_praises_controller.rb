module Open
  module V2
    class PublicPraisesController < Open::ApplicationController
      def index
        param! :order_field, String, default: "id"
        param! :order_by, String, in: %w(asc desc), default: "desc"
        param! :page, Integer, default: 1
        param! :per_page, Integer, default: 5

        car = Car.find(params[:car_id])
        sumup = PublicPraise::Sumup.find_by(style_name: car.style_name)
        records = PublicPraise::Record.where(sumup_id: sumup.try(:id))

        render json: paginate(records),
               each_serializer: PublicPraiseSerializer::Record,
               root: "data",
               meta: {
                 count: sumup.try(:records).try(:size) || 0
               }
      end

      def sumup
        car = Car.find(params[:car_id])
        empty_data = { data: {} }

        unless Megatron.style_present?(car.series_name, car.style_name)
          return render json: empty_data
        end

        service = PublicPraiseService.new(car.brand_name, car.series_name, car.style_name)

        sumup = if service.mutex_alive? # 有一个任务正在解析
                  service.processing_thread
                else
                  service.execute
                end

        return render json: empty_data if !sumup || sumup.empty?

        render json: sumup,
               serializer: PublicPraiseSerializer::OpenSumup,
               root: "data",
               meta: {
                 count: sumup.records.size
               }
      rescue AutohomePublicPraise::ModelBaseNotMatched
        return render json: empty_data
      end
    end
  end
end
