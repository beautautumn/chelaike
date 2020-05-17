module V1
  class PublicPraisesController < ApplicationController
    serialization_scope :anonymous

    before_action :skip_authorization
    skip_before_action :authenticate_user!

    def index
      basic_params_validations

      car = Car.find(params[:car_id])

      sumup = PublicPraise::Sumup.find_by!(style_name: car.style_name)
      records = PublicPraise::Record.where(sumup_id: sumup.id)

      render json: paginate(records),
             each_serializer: PublicPraiseSerializer::Record,
             root: "data"
    end

    def sumup
      car = Car.find(params[:car_id])

      unless Megatron.style_present?(car.series_name, car.style_name)
        return head :no_content
      end

      service = PublicPraiseService.new(car.brand_name, car.series_name, car.style_name)

      return already_accepted if service.mutex_alive? # 有一个任务正在解析
      sumup = service.execute

      return not_found("暂无数据") if sumup.empty?

      render json: sumup,
             serializer: PublicPraiseSerializer::Sumup,
             root: "data"
    rescue AutohomePublicPraise::ModelBaseNotMatched
      return not_found("车型匹配不成功")
    end
  end
end
