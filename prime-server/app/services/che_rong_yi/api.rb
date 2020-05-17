module CheRongYi
  class Api
    class RequestError < StandardError; end

    class << self
      # 根据ID得到对应借款单详情
      def loan_bill(id)
        url = "/loan_bill/#{id}"
        result = request(
          method: :get,
          url: url
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        CheRongYi::LoanBill.new(content[:data])
      end

      # 创建借款单
      def create_loan_bill(params)
        # car_ids, shop_id, funder_company_id, estimate_borrow_amount_cents
        # cars;                      //车辆信息List<CarDto> cars;
        # shopId;                  //借款方id
        # funderCompanyId;           //资金方id
        # estimateBorrowAmountCents; //预计申请额度

        url = "/loan_bill/create"

        result = request(
          method: :post,
          url: url,
          params: {
            loanBillData: loan_bill_data(params)
          }
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        content[:data]
      end

      def loan_bills(params)
        # funder_company_id, brand_name, shop_id, page, size, state, replace_history
        # funderCompanyId  //资金方公司Id
        # brandName    //品牌
        # shopId   //车商id
        # page        //当前页码-1
        # size    //页面展示条数
        # state    //借款状态
        # replaceHistory //有无换车历史（replace_history：有换车记录；not_replace_history：无换车记录）

        extra_params = [
          "page=#{params[:page]}",
          "size=#{params[:per_page]}",
          "shopId=#{params[:shop_id]}",
          "brandName=#{params[:brand_name]}",
          "funderCompanyId=#{params[:funder_company_id]}",
          "state=#{params[:state].try(:join, ',')}",
          "replaceHistory=#{params[:replace_history]}"
        ].join("&")

        Rails.logger.info("[CheRongYi::Api#loan_bills] extra_params is: #{extra_params}")
        url = "/loan_bill/index?#{extra_params}"

        result = request(
          method: :get,
          url: URI.escape(url)
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200

        loan_bills = content[:data][:content].map do |loan_bill_params|
          CheRongYi::LoanBill.new(loan_bill_params)
        end

        {
          loan_bills: loan_bills,
          total_count: content[:data][:totalElements],
          per_page: params[:per_page]
        }
      end

      # 根据车商ID得到授信情况
      def loan_accredited_records(shop_id)
        url = "/loan_accredit_record/#{shop_id}"

        result = request(
          method: :get,
          url: url
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        content[:data].map do |data|
          CheRongYi::LoanAccreditedRecord.new(data)
        end
      end

      def create_replace_cars_bill(params)
        # loan_bill_id, will_replace_car_ids, is_replaced_car_ids, no_replace_car_ids,
        # current_amount_wan, user_id, shop_id
        url = "/transferCar/create"

        result = request(
          method: :post,
          url: url,
          params: {
            replaceCarBill: replace_car_bill_params(params)
          }
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        CheRongYi::ReplaceCarsBill.new(content[:data])
      end

      def replace_cars_bill(replace_car_bill_id)
        url = "/transferCar/carDetail/#{replace_car_bill_id}"
        result = request(
          method: :get,
          url: url
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        CheRongYi::ReplaceCarsBill.new(content[:data])
      end

      def create_repayment_bill(params)
        url = "/repayment_bill/create"
        # params = { car_ids:, loan_bill_id:, repayment_amount_wan: }
        result = request(
          method: :post,
          url: url,
          params: {
            repaymentBill: repayment_bill_params(params)
          }
        )

# {:message=>"success",
#  :data=>
#   {:id=>2050 },
#  :code=>200}

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        CheRongYi::RepaymentBill.new(content[:data])
      end

      def repayment_bill(repayment_bill_id)
        url = "/repayment_bill/#{repayment_bill_id}"

        result = request(
          method: :get,
          url: url
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        CheRongYi::RepaymentBill.new(content[:data])
      end

      # 申请还款时得到一些基本信息
      def repayment_apply(loan_bill_id)
        url = "/repayment_bill/apply/#{loan_bill_id}"

        result = request(
          method: :get,
          url: url
        )

        content = result[:content]

        raise CheRongYi::Api::RequestError, content[:errors] unless result[:code] == 200
        CheRongYi::RepaymentBill.new(content[:data])
      end

      private

      def host
        domain = ENV["CHERONGYI_HOST"]
        return "#{domain}/api/open/v1" unless Rails.env.production?
        "#{domain}/api/open/v1"
      end

      def request(method: , url: , params: nil, struct_response: true)
        token = { "token": ENV["CHERONGYI_REQUEST_TOKEN"] }

        response = RestClient::Request.execute(
          method: method,
          url: host + url,
          payload: params,
          headers: token,
          timeout: 5
        )

        {
          content: MultiJson.load(response.body, symbolize_keys: true),
          code: response.code
        }
      rescue RestClient::ExceptionWithResponse => err
        {
          content: MultiJson.load(err.response.body, symbolize_keys: true),
          code: err.response.code
        }
      end

      def loan_bill_data(params)
        company_weshop_domain = ::Car::WeshopService.new.official_company_domain(params[:shop_id])

        {
          cars: convert_cars_dto(
            params[:car_ids],
            company_domain: company_weshop_domain
          ),
          shopId: params[:shop_id],
          spCompanyId: 1,
          funderCompanyId: params[:funder_company_id],
          estimateBorrowAmountCents: params[:estimate_borrow_amount_cents]
        }.to_json
      end

      # 匹配java字段要求
      def convert_cars_dto(car_ids, company_domain: "")
        cars = ::Car.where(id: car_ids)
        result = []

        cars.each do |car|
          result << convert_car_dto(car, company_domain: company_domain)
        end

        result
      end

      def convert_car_dto(car, company_domain: "")
        acquisition_transfer = car.acquisition_transfer
        transfer_images = acquisition_transfer.images
        {
          brandName: car.brand_name,
          seriesName: car.series_name,
          styleName: car.style_name,
          companyId: car.company_id,
          shopId: car.shop_id,
          estimatePriceCents: car.estimate_price_cents,
          licencedAt: car.licensed_at.try(:to_formatted_s, :db),
          showPriceCents: car.show_price_cents,
          mileage: car.mileage,
          exteriorColor: car.exterior_color,
          keysCount: car.acquisition_transfer.try(:key_count),
          vin: car.vin,
          checkReportUrl: car.check_tasks.last.try(:report_url),
          checkReportType: car.check_tasks.last.try(:report_type),
          chelaikeCarId: car.id,
          drivingLicense: transfer_images.where(location: "driving_license").first.try(:url),
          registrationLicense: transfer_images.where(location: "registration_license").first.try(:url),
          insurance: transfer_images.where(location: "insurance").first.try(:url),
          images: car_images_dto(car),
          weshopUrl: "#{company_domain}/cars/#{car.id}" # 微店地址
        }
      end

      def car_images_dto(car)
        result = []

        car.images.each do |image|
          result << {
            url: image.url,
            name: image.name,
            location: image.location,
            isCover: image.is_cover
          }
        end

        result
      end

      def replace_car_bill_params(params)
        company_weshop_domain = ::Car::WeshopService.new.official_company_domain(params[:shop_id])
        cars_hash = will_replace_cars(
          params[:will_replace_car_ids], company_domain: company_weshop_domain
        ) + replaced_cars(params[:is_replaced_car_ids]) +
                    no_replace_cars(params[:no_replace_car_ids])

        is_replaced_amount = is_replaced_total_amount(params[:is_replaced_car_ids])
        no_replace_amount = no_replace_total_amount(params[:no_replace_car_ids])

        {
          cars: cars_hash,
          currentAmountCents: is_replaced_amount + no_replace_amount,
          debtorId: params[:shop_id],
          loanBillId: params[:loan_bill_id],
          replaceAmountCents: replace_cars_total_amount(params[:will_replace_car_ids]).to_i, # 替换上来的车辆总估值
          isReplacedAmountCents: is_replaced_amount
        }.to_json
      end

      def will_replace_cars(will_replace_car_ids, company_domain: "")
        cars = ::Car.where(id: will_replace_car_ids)

        result = []
        cars.each do |car|
          result << {
            car: convert_car_dto(car, company_domain: company_domain),
            state: "will_replace"
          }
        end

        result
      end

      def replaced_cars(is_replaced_car_ids)
        is_replaced_car_ids.each_with_object([]) do |car_id, a|
          a << { car: { chelaikeCarId: car_id, images: [] }, state: "is_replaced" }
        end
      end

      def no_replace_cars(no_replace_car_ids)
        return [] unless no_replace_car_ids
        no_replace_car_ids.each_with_object([]) do |car_id, a|
          a << { car: { chelaikeCarId: car_id, images: [] }, state: "no_replace" }
        end
      end

      def replace_cars_total_amount(will_replace_car_ids)
        ::Car.where(id: will_replace_car_ids).sum(:estimate_price_cents).to_i
      end

      def is_replaced_total_amount(is_replaced_car_ids)
        ::Car.where(id: is_replaced_car_ids).sum(:estimate_price_cents).to_i
      end

      def no_replace_total_amount(no_replace_car_ids)
        ::Car.where(id: no_replace_car_ids).sum(:estimate_price_cents).to_i
      end

      def repayment_bill_params(params)
        {
          cheLaiKeIds: params[:car_ids],
          loanBillId: params[:loan_bill_id],
          repaymentAmountCents: (params[:repayment_amount_wan].to_d * 1_000_000).to_i
        }.to_json
      end
    end
  end
end
