module V1
  class ImportTasksController < ApplicationController
    before_action :skip_authorization

    def index
      basic_params_validations

      import_tasks = paginate import_task_scope
                     .includes(:user)
                     .ransack(params[:query]).result
                     .order(id: :desc)

      render json: import_tasks,
             each_serializer: ImportTaskSerializer::Common,
             root: "data"
    end

    private

    def import_task_scope
      ImportTask.where(company_id: current_user.company_id)
    end
  end
end
