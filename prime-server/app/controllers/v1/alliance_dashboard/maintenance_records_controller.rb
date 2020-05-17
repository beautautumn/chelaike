module V1
  module AllianceDashboard
    class MaintenanceRecordsController < V1::AllianceDashboard::ApplicationController
      def detail
        @car = Car.find(params[:car_id])
        detail_fetch
        ant_queen_fetch
        cha_doctor_fetch
        dasheng_fetch
        wrapper = CombinedSerializers.new(
          ant_queen_record: @ant_queen || AntQueenRecord.new,
          cha_doctor_record: @cha_doctor || ChaDoctorRecord.new,
          maintenance_record: @record || MaintenanceRecord.new,
          dashenglaile_record: @dasheng || DashenglaileRecord.new,
          maintenance_images: @car.try(:maintenance_images)
        )

        render json: wrapper,
               serializer: MaintenanceRecordSerializer::Wrapper,
               root: :data
      end

      private

      # 所有平台在联盟后台优先使用最新的维保报告
      def detail_fetch
        return unless @car
        @record = (@car.vin.presence &&
                   MaintenanceRecord.order(last_fetch_at: :desc).find_by(vin: @car.vin)) ||
                  MaintenanceRecord.find_by(car_id: params[:car_id])
        return unless @record
        @record.car_id = @car.id
        @record.state = :checked if @record.state.unchecked?
        @record.save!
      end

      def ant_queen_fetch
        return unless @car
        @ant_queen = (@car.vin.presence &&
                       AntQueenRecord.order(last_fetch_at: :desc).find_by(vin: @car.vin)) ||
                     AntQueenRecord.find_by(car_id: params[:car_id])
        return unless @ant_queen
        @ant_queen.car_id = @car.id
        @ant_queen.state = :checked if @ant_queen.state.unchecked?
        @ant_queen.save!
      end

      def cha_doctor_fetch
        return unless @car
        @cha_doctor = (@car.vin.presence &&
                        ChaDoctorRecord.order(fetch_at: :desc).find_by(vin: @car.vin)) ||
                      ChaDoctorRecord.find_by(car_id: params[:car_id])
        return unless @cha_doctor
        @cha_doctor.car_id = @car.id
        @cha_doctor.state = :checked if @cha_doctor.state.unchecked?
        @cha_doctor.save!
      end

      def dasheng_fetch
        return unless @car
        @dasheng = (@car.vin.presence &&
                      DashenglaileRecord.order(last_fetch_at: :desc).find_by(vin: @car.vin)) ||
                   DashenglaileRecord.find_by(car_id: params[:car_id])
        return unless @dasheng
        @dasheng.car_id = @car.id
        @dasheng.state = :checked if @dasheng.state.unchecked?
        @dasheng.save!
      end
    end
  end
end
