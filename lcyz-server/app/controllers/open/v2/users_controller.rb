module Open
  module V2
    class UsersController < Open::ApplicationController
      def show
        user = if current_company.open_alliance_id
                 current_company.open_allied_users.find(params[:id])
               else
                 current_company.users.find(params[:id])
               end

        render json: user,
               serializer: UserSerializer::Mini,
               root: "data",
               meta: { version_catagory: version_catagory }
      end
    end
  end
end
