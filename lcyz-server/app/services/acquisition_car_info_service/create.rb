module AcquisitionCarInfoService
  class Create
    include ErrorCollector
    attr_accessor :info

    def initialize(user, info_params)
      @user = user
      @params = info_params
    end

    def execute(chat_id: nil, chat_type: "private")
      @info = AcquisitionCarInfo.new(
        @params.merge(
          acquirer_id: @user.id,
          company_id: @user.company_id
        )
      )

      fallible @info
      begin
        @info.save!

        if chat_id.present?
          @info.publish_records.create!(
            chatable_id: chat_id, chatable_type: transfer_type(chat_type)
          )
        end

        customer = find_or_init_customer
        associate_customer!(customer) if customer.present?

      rescue ActiveRecord::RecordInvalid
        @info
      end

      self
    end

    private

    def find_or_init_customer
      owner_intention = @info.owner_intention
      customer_phone = owner_intention.phone
      if customer_phone.present?
        customer = @user.company.customers.phones_include(customer_phone).first
        customer = @user.customers.new(
          company_id: @user.company_id,
          name: owner_intention.name,
          phone: owner_intention.phone,
          phones: [owner_intention.phone],
          user_id: @user.id
        ) unless customer
        customer
      end
    end

    def associate_customer!(customer)
      owner_intention = @info.owner_intention
      customer.assign_attributes(
        company_id: @user.company_id,
        name: owner_intention.name,
        phone: owner_intention.phone,
        phones: [owner_intention.phone],
        user_id: @user.id
      )
      customer.save!
      create_intention!(customer, owner_intention)
    end

    def create_intention!(customer, owner_intention)
      Intention.create!(
        customer_id: customer.id,
        customer_name: customer.name,
        intention_type: "sale",
        creator_id: @user.id,
        assignee_id: @user.id,
        intention_level_id: owner_intention.intention_level.fetch("id", nil),
        company_id: @user.company_id,
        shop_id: @user.shop_id,
        customer_phones: customer.phones,
        state: "untreated",
        customer_phone: customer.phone,
        minimum_price_wan: owner_intention.expected_price_wan,
        maximum_price_wan: owner_intention.expected_price_wan
      )
    end

    def transfer_type(group)
      {
        group: "ChatGroup",
        private: "User"
      }.fetch(group.to_sym, "User")
    end
  end
end
