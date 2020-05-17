module V1
  class PublishProfilesController < ApplicationController
    before_action :skip_authorization
    before_action :find_che168_profile

    def show
      render json: {
        data: {
          che168: @che168_profile
        }
      }, scope: nil
    end

    def validation
      che168 = CarPublisher::Che168Worker::Helper.login?(@che168_profile.data["cookies"])

      render json: {
        data: {
          che168: che168
        }
      }, scope: nil
    end

    def update
      @che168_profile.assign_attributes(che168_profile_params)
      @che168_profile.save

      begin
        CarPublisher::Che168Worker::Helper.login(@che168_profile)
      rescue CarPublisher::Che168Worker::Error::InvalidLoginInfo
        @che168_profile
      end

      if @che168_profile.errors.empty?
        render json: {
          data: {
            che168: @che168_profile
          }
        }, scope: nil
      else
        validation_error(full_errors(@che168_profile))
      end
    end

    def destroy
      case params[:type]
      when "che168"
        @che168_profile.destroy
      end

      render json: {
        data: {
          che168: current_company.reload.che168_profile || current_company.build_che168_profile
        }
      }, scope: nil
    end

    private

    def che168_profile_params
      params.require(:che168).permit(data: [:username, :password])
    end

    def current_company
      current_user.company
    end

    def find_che168_profile
      @che168_profile = current_company.che168_profile ||
                        current_company.build_che168_profile
    end
  end
end
