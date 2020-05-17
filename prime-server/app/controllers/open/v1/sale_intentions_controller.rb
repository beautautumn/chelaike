module Open
  module V1
    class SaleIntentionsController < Open::ApplicationController
      def new
        service = Intention::CreateService.new(
          seller, Intention, intention_params
        )
        service.execute

        if service.valid?
          intention = service.intention
          intention.transfer_to_acquisition_info(:online)
          render json: { message: :ok }, scope: nil
        else
          validation_error(service.errors)
        end
      end

      private

      def sale_intention_params
        params.require(:sale_intention).permit(
          :car_id, :brand_name, :series_name, :style_name, :mileage, :licensed_at,
          :phone, :province, :city, :expected_price_wan, :expected_price_yuan
        )
      end

      def intention_params
        input = sale_intention_params

        assignee_user = assignee || seller

        channel = assignee_user.company.channels.find_or_create_by(name: "微店")

        input_price(input).merge!(
          customer_phone: input[:phone],
          brand_name: input[:brand_name],
          series_name: input[:series_name],
          style_name: input[:style_name],
          mileage: input[:mileage],
          licensed_at: input[:licensed_at],
          province: input[:province],
          city: input[:city],
          intention_type: "sale",
          assignee_id: assignee_user.id,
          company_id: assignee_user.company_id,
          channel_id: channel.id,
          state: "untreated"
        )
      end

      def input_price(input)
        if input[:expected_price_yuan].present?
          {
            minimum_price_yuan: input[:expected_price_yuan],
            maximum_price_yuan: input[:expected_price_yuan]
          }
        else
          {
            minimum_price_wan: input[:expected_price_wan],
            maximum_price_wan: input[:expected_price_wan]
          }
        end
      end

      def seller
        @seller ||= if params[:seller_id].present?
                      User.find(params[:seller_id])
                    elsif params[:car_id].present?
                      Car.find(params[:car_id]).company.owner
                    else
                      current_company.owner
                    end
      end

      def assignee
        @assignee ||= if seller.can?("出售客户管理")
                        seller
                      else
                        User.where(company_id: seller.company_id)
                            .authorities_include("出售客户管理")
                            .first
                      end
      end
    end
  end
end
