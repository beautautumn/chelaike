module Dashboard
  class VinImagesController < ApplicationController
    include ApplicationHelper

    helper_method :get_state_name, :get_sp_name, :get_states_arrary

    skip_before_action :authenticate_staff!, only: [:show, :response_error, :start_query]
    skip_after_action :verify_authorized, only: [:show, :response_error, :start_query]
    before_action do
      authorize :dashboard_vin_image
    end

    def index
      @q = UnionMaintenanceRecord.all

      if (params[:sp_type].present?)
        @q = @q.where(sp_type: params[:sp_type])
      else
        @q = @q.where(sp_type: ['drCha', 'monkeyKing'])
      end

      @q = @q.where(state: params[:state]) if (params[:state].present?)

      @q = @q.ransack(params[:q])
      @vin_images = @q.result
        .includes(:company)
        .order(created_at: :desc)
        .page(params[:page])
        .per(20)
      @counter = @q.result.count
      store_location
    end

    def show
      decode_id = Base64.decode64(params[:id])
      @record = UnionMaintenanceRecord.find_by(id: decode_id)

      render layout: "dashboard/vin"
    end

    def response_error
      record = vin_image_params
      result = call_sp_service(record, true)
      redirect_by_os(result)
    end

    def start_query
      record = vin_image_params
      result = call_sp_service(record)
      redirect_by_os(result)
    end

    private
      def redirect_by_os(result)
        if params[:is_from_mobile]
          id = vin_image_params[:sp_type] + vin_image_params[:original_id]
          redirect_to vin_image_path(Base64.urlsafe_encode64(id)),
                      :flash => result
        else
          redirect_to vin_images_path, :flash => result
        end
      end

      def call_sp_service(record, failed = false)
        id = record[:original_id]
        vin = record[:vin]
        error_info = record[:error_info]

        result = { success: "操作成功"}

        begin
          if record[:sp_type] == 'drCha'
            record = ChaDoctorRecord.find(id)
            ChaDoctorService::Fetch
              .new(vin, nil)
              .fire(record, failed, error_info)
          elsif record[:sp_type] == 'monkeyKing'
            record = DashenglaileRecord.find(id)
            Dashenglaile::FetchService
              .new(vin, nil, nil)
              .fire(record, failed, error_info)
          end
        rescue Exception => e
          result = { danger: e.message}
        ensure
          return result
        end
      end

      def vin_image_params
        params.require(:union_maintenance_record)
          .permit(:original_id, :sp_type, :vin, :error_info, :user_id)
      end

      def state_names
        {
          'submitted' => '已提交',
          'generating' => '生成中',
          'updating' => '更新中',
          'unchecked' => '已生成',
          'checked' => '已查看',
          'generating_fail' => '生成失败',
          'updating_fail' => '更新失败',
          'vin_image_fail' => 'VIN码图片无法识别'
        }
      end

      def get_state_name(state)
        state_names.fetch(state, state)
      end

      def get_states_arrary
        names= state_names
        state_names.keys.map {|key| [names[key], key]}
      end

      def get_sp_name(sp)
        sp_names = {
          'drCha' => '查博士',
          'monkeyKing' => '大圣来了'
        }
        sp_names.fetch(sp, sp)
      end
  end
end
