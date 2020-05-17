module V1
  class WarrantiesController < ApplicationController
    before_action do
      authorize Warranty
    end

    def index
      render json: warranty_scope.order(id: :desc),
             each_serializer: WarrantySerializer::Common,
             root: "data"
    end

    def create
      warranty = warranty_scope.create(warranty_params)

      if warranty.errors.empty?
        render json: warranty,
               serializer: WarrantySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(warranty))
      end
    end

    def update
      warranty = warranty_scope.find(params[:id])
      warranty.update(warranty_params)

      if warranty.errors.empty?
        render json: warranty,
               serializer: WarrantySerializer::Common,
               root: "data"
      else
        validation_error(full_errors(warranty))
      end
    end

    def destroy
      render json: warranty_scope.find(params[:id]).destroy,
             serializer: WarrantySerializer::Common,
             root: "data"
    end

    private

    def warranty_params
      params.require(:warranty).permit(:name, :fee, :note)
    end

    def warranty_scope
      Warranty.where(company_id: current_user.company_id)
    end
  end
end
