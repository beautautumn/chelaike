module V1
  class Parallel::BrandsController < ApplicationController
    before_action :skip_authorization

    def index
      brand_type = params[:type] == "special" ? "special_offer" : "parallel_import"

      all_brands = paginate ::Parallel::Brand
                   .where(brand_type: brand_type)
                   .where("styles_count > 0")

      brands = all_brands.ransack(params[:query]).result
      hot_brands = all_brands.hot.take(4)
      phone = ::Parallel::Phone.first

      render json: brands,
             each_serializer: ParallelBrandSerializer::Common,
             meta: {
               hot_brands: hot_brands,
               phone: phone ? phone.slice(:number) : nil
             },
             root: "data"
    end

    def show
      brand = ::Parallel::Brand.find(params[:id])
      phone = ::Parallel::Phone.first

      render json: brand,
             serializer: ParallelBrandSerializer::Detail,
             meta: {
               phone: phone ? phone.slice(:number) : nil
             },
             root: "data", include: "**"
    end
  end
end
