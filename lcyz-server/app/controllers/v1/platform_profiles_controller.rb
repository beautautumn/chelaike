module V1
  class PlatformProfilesController < ApplicationController
    before_action :skip_authorization
    before_action :find_platform_profile

    def show
      render json: {
        data: {
          platform_profile: @platform_profile.data
        }
      }, scope: nil
    end

    # 二手车之家，易车网得到联系人
    def contacts
      return_hash = {}
      # [:che168, :yiche].each do |platform|
      #   return_hash[platform] = @platform_profile.contacts(platform)
      # end

      render json: {
        data: {
          contacts: return_hash
        }
      }, scope: nil
    end

    def brands
      brands = publish_service(params[:platform]).brands

      render json: {
        data: {
          brands: brands
        }
      }, scope: nil
    end

    def series
      brand_id = params[:brand_id]
      series = publish_service(params[:platform]).series(brand_id)

      render json: {
        data: {
          series: series
        }
      }, scope: nil
    end

    def styles
      series_id = params[:series_id]
      styles = publish_service(params[:platform]).styles(series_id)

      render json: {
        data: {
          styles: styles
        }
      }, scope: nil
    end

    # 得到同步状态
    def sync_states
      car_id = params[:car_id]

      render json: {
        data: Car::SyncService.new(current_user.id, car_id).sync_states
      }, scope: nil
    end

    # 验证各平台同步信息
    # 传入所要同步平台
    def validate_missings
      # params: { platforms: [:che168, :yiche], car_id: 1234 }
      platforms = params[:platforms]
      car = Car.find params[:car_id]

      return_hash = platforms.each_with_object({}) do |platform, hash|
        hash[platform] = publish_service(platform).validate_missings(car)
        hash
      end

      render json: {
        data: { missing_fields: return_hash }
      }, scope: nil
    end

    # 绑定帐号
    def update
      profile = params[:profile]
      platform = profile.fetch("platform")
      data = profile.fetch("data")

      company = current_user.company

      platform_profile = company.platform_profile || company.create_platform_profile
      platform_profile.update_profile(platform, data)
      platform_profile.update_extras(platform, is_success: true)

      render json: {
        data: {
          platform_profile: @platform_profile.data
        }
      }
      # peter at 2016.8.17
      # 暂时先禁用，不要移除代码
      # profile = params[:profile]
      # platform = profile.fetch("platform")
      # data = profile.fetch("data")

      # username = data.fetch(:username)
      # password = data.fetch(:password)

      # begin
      #   service = Publisher::PublishService.new(current_user.id, platform)
      #   service.bind_account(username: username, password: password,
      #                        data: data
      #                       )

      #   render json: {
      #     data: {
      #       platform_profile: @platform_profile.reload.data
      #     }
      #   }, scope: nil
      # rescue CarPublisher::LoginError
      #   validation_error("设置失败：账号或密码出现错误，请重新填写!")
      # end
    end

    # 解除绑定
    def destroy
      platform = params[:platform]
      @platform_profile.unbind(platform)

      render json: {
        data: {
          platform_profile: @platform_profile.reload.data
        }
      }, scope: nil
    end

    private

    def publish_service(platform)
      Publisher::PublishService.new(current_user.id, platform)
    end

    def current_company
      current_user.company
    end

    def find_platform_profile
      @platform_profile = current_company.platform_profile ||
                          current_company.build_platform_profile
    end
  end
end
