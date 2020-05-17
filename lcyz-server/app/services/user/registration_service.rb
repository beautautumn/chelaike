class User < ActiveRecord::Base
  class RegistrationService
    include ErrorCollector

    attr_reader :owner, :company

    def initialize(user_params, company_params)
      @user_params = user_params.merge!(name: company_params[:contact],
                                        is_alliance_contact: true)
      @company_params = company_params
    end

    def execute(req_headers = {})
      begin
        @owner = User.includes(:owner).new(@user_params)
        @company = @owner.build_owned_company(@company_params)
        @shop = Shop.create(name: @company.name)
        @owner.shop_id = @shop.id

        fallible @owner, @company, @shop

        User.transaction do
          @owner.company = @company
          @company.save!
          @owner.save!
          @shop.update!(company_id: @company.id)

          User::AuthorityService.new(@owner).init_default_roles!
          User::SessionService.new(@owner).create(@user_params[:password], req_headers)

          self.class.init_intention_levels(@company)
          self.class.init_channels(@company)

          PriceTagTemplateCreateWorker.perform_in(5.seconds, @owner.id)
        end

        init_chat_groups(@company)

      rescue ActiveRecord::RecordInvalid
        @shop.destroy
        @owner
      end

      self
    end

    def self.init_intention_levels(company)
      levels = {
        "H" => 1,
        "A" => 3,
        "B" => 5,
        "C" => 7,
        "D" => 30
      }

      levels.each do |level, days|
        company.intention_levels.create(
          name: "#{level}级",
          time_limitation: days
        )
      end
    end

    def self.init_channels(company)
      names = %w(门店 朋友介绍 同行批发 网络集客)

      names.each do |name|
        company.channels.find_or_create_by(name: name)
      end
    end

    private

    def init_chat_groups(company)
      InitCompanyChatWorker.perform_async(company.id)
    end
  end
end
