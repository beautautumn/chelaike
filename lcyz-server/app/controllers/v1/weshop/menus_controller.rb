module V1
  class Weshop::MenusController < ApplicationController
    before_action do
      authorize WechatApp
    end
    before_action :validate_params, only: :update
    before_action :find_wechat_app

    def show
      render json: { data: respond_data }, scope: nil
    end

    def update
      @wechat_app.update!(menus: params[:menus])
      render json: { data: respond_data }, scope: nil
    end

    def publish
      param! :state, String, in: %w(editing published), default: "published"

      Wechat::MenusPublishService.new(@wechat_app, params[:state]).execute
      render json: { data: respond_data }, scope: nil
    rescue Wechat::Error::Menu => e
      bad_request("菜单数据有误", e)
    end

    private

    def find_wechat_app
      @wechat_app = WechatApp.find_by(company_id: current_user.company_id)
      render(json: { data: {} }, scope: nil) unless @wechat_app
    end

    def respond_data
      {
        title: @wechat_app.nick_name,
        state: @wechat_app.menus_state,
        menus: @wechat_app.menus,
        verify_type_info:  @wechat_app.verify?,
        service_type_info: @wechat_app.service_type_info
      }
    end

    def validate_params
      param! :menus, Array, required: true do |menu|
        menu.param! :name, String, blank: false
        menu.param! :cate, String, in: Wechat::Mp::Menu::ButtonType
        menu.param! :message, String
        menu.param! :url, String
        menu.param! :children, Array, default: [] do |child|
          child.param! :name, String, blank: false
          child.param! :cate, String, in: Wechat::Mp::Menu::ButtonType
          child.param! :message, String
          child.param! :url, String
        end
      end
    end
  end
end
