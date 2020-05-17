module V1
  class PublishersController < ApplicationController
    before_action :skip_authorization

    def index
      render json: current_car,
             serializer: CarSerializer::Publishers,
             root: "data", include: "**"
    end

    def sync
      Publisher::Che168Service.new(current_user, current_car, publishers_params[:che168])
                              .execute

      render json: current_car,
             serializer: CarSerializer::Publishers,
             root: "data", include: "**"
    end

    def che168_state_sync
      che168_id = current_car.che168_publish_record.che168_id

      unless che168_id.blank?
        CarPublisher::Che168Worker::Helper.sync_che168_state(
          che168_id, current_car, che168_cookies || {})
      end

      render json: current_car,
             serializer: CarSerializer::Publishers,
             root: "data", include: "**"
    end

    # 同步某个车辆
    def publish
      car_id = params[:car_id]
      relations = params[:relations].map(&:stringify_keys)
      extra_attrs = params[:extra_attrs].deep_stringify_keys

      relations.each do |relation|
        platform = relation.fetch("platform")

        # service = Publisher::PublishService.new(current_user.id, platform)
        # service.create(car_id, extra_attrs.fetch(platform), relation.fetch("contactor"))
        PublishCarWorker.perform_async(current_user.id,
                                       platform,
                                       car_id,
                                       extra_attrs.fetch(platform),
                                       relation.fetch("contactor")
                                      )
      end

      render json: { data: { message: "后台任务已在同步" } }, scope: nil
    end

    def destroy
      car_id = params[:car_id]
      platform = params[:platform]

      service = Publisher::PublishService.new(current_user.id, platform)
      if service.delete(car_id)
        render json: { data: { status: true, message: "" } }, scope: nil
      else
        render json: { data: { status: false, message: "删除失败" } }, scope: nil
      end
    end

    private

    def publishers_params
      params.require(:publishers).permit(che168: [:syncable, :seller_id])
    end

    def current_company_cars
      Car.where(company_id: current_user.company_id)
    end

    def che168_cookies
      profile = current_user.company.che168_profile.try(:data)

      profile["cookies"] if profile
    end

    def current_car
      current_company_cars.find(params[:car_id])
    end
  end
end
