module V1
  class CustomersController < ApplicationController
    before_action :skip_authorization, except: :destroy
    before_action :find_customer, except: [:create, :index, :import, :follow_up, :memory_dates]
    before_action only: :destroy do
      authorize Customer
    end

    def index
      param! :order_by, String, in: %w(asc desc), default: "asc"
      param! :query, Hash

      record_recent_keywords(:customers)
      customers = current_user.customers
                              .ransack(params[:query]).result.uniq
                              .order("first_letter ASC NULLS LAST")
                              .order("customers.id")

      render json: customers,
             each_serializer: CustomerSerializer::List,
             root: "data",
             batch_avatars: FirstLetterAvatar.batch_avatars(customers)
    end

    def intentions
      param! :query, Hash

      intentions = @customer.intentions
                            .ransack(params[:query]).result
                            .includes(:assignee, :intention_level, :channel)
                            .order(:id)

      render json: intentions,
             each_serializer: IntentionSerializer::Common,
             root: "data"
    end

    def follow_up
      param! :order_by, String, in: %w(asc desc), default: "asc"
      param! :query, Hash

      customers = current_user.customers
                              .follows_up(current_user.id)
                              .ransack(params[:query])
                              .result
                              .order("first_letter ASC NULLS LAST")

      render json: customers, each_serializer: CustomerSerializer::Common, root: "data"
    end

    def show
      render json: @customer, serializer: CustomerSerializer::Common, root: "data"
    end

    def create
      service = Customer::CreateService.new(current_user, customer_params)
      customer = service.execute.customer

      if customer.errors.empty?
        render json: customer, serializer: CustomerSerializer::Common, root: "data"
      else
        validation_error(customer.errors)
      end
    end

    def import
      customers_params = params[:customers].map { |e| customer_params(e) }
      filtered_phones = Customer::ImportService
                        .new(current_user, customers_params)
                        .execute.filtered_phones

      render json: { data: { filtered_phones: filtered_phones } }, scope: nil
    end

    def update
      # @customer.update(customer_params)
      service = Customer::UpdateService.new(current_user, @customer)

      service.update(customer_params)

      if @customer.errors.empty?
        render json: @customer, serializer: CustomerSerializer::Common, root: "data"
      else
        validation_error(full_errors(@customer))
      end
    end

    def destroy
      @customer.destroy
      render json: @customer, serializer: CustomerSerializer::Common, root: "data"
    end

    # 得到可选节日列表
    def memory_dates
      dates_hash = %w(生日 爱人生日 父亲生日 母亲生日 小孩生日 结婚纪念日)
      render json: { data: dates_hash },
             scope: nil
    end

    private

    def customer_params(customer = nil)
      customer ||= params.require(:customer)

      # 防止空数组变成nil
      customer[:phones] ||= [] if customer && customer.key?(:phones)

      customer.permit(
        :name, :phone, :gender, :id_number, :note, :avatar,
        { memory_dates: [:name, :date, :notification_id] }, phones: []
      )
    end

    def find_customer
      @customer = current_user.customers.find(params[:id])
    end
  end
end
