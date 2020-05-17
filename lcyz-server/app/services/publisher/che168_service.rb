module Publisher
  class Che168Service
    def initialize(user, car, params = nil)
      @params = params || {}
      @user = user
      @company = @user.company
      @car = car
    end

    def execute(action = nil)
      syncable = @params[:syncable]

      che168_publish_record.assign_attributes(
        company_id: @company.id, syncable: syncable, seller_id: @params[:seller_id]
      )
      che168_publish_record.save!

      # 这里要先判断记录是否在同步中
      return if syncable.blank? || che168_publish_record.state.processing?

      # 这里进入同步流程之前，要先把状态重置为同步中。
      che168_publish_record.state = "processing"
      che168_publish_record.save!

      args = [@company.id, che168_publish_record.id, action].compact
      CarPublisher::Che168Worker.perform_async(*args)
    end

    private

    def che168_publish_record
      @car.che168_publish_record || @car.build_che168_publish_record
    end
  end
end
