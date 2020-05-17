module EasyLoanService
  class Lib
    class << self
      def estimate_car_price_wan(car_id, accredited_record)
        # TODO: 车三百估值价格*金融贷款比例
        # 先使用车三百估值，如果没有返回值，用0代替
        car = Car.find(car_id)

        estimated = eval_price(car)
        remaining_amount_wan = accredited_record.remaining_amount_wan
        return remaining_amount_wan if estimated >= remaining_amount_wan
        estimated
      end

      def estimate_dealer_buy_price(car_id)
        car = Car.find(car_id)

        dealer_buy_price(car)
      end

      private

      def che3bai_estimate_price(car)
        che3bai = Che3bai::LoanService.new

        model_id = Megatron.style_id(car.series_name, car.style_name)

        reg_date = car.licensed_at.strftime("%Y-%m")
        city_name = car.company.city
        mile = car.mileage
        zone = che3bai.city(city_name)

        che3bai.estimate(model_id, reg_date, mile, zone)
        # {"status"=>"1", "eval_price"=>7.99, "low_price"=>7.08, "good_price"=>7.46, "high_price"=>7.99, "dealer_buy_price"=>7.51, "individual_price"=>7.99, "dealer_price"=>8.25, "url"=>"https://www.che300.com/pinggu/v12c12m23839r2016-08g3.0?from=yunchao", "price"=>"10.59", "discharge_standard"=>"国5", "title"=>"锐行  2015款 锐行 1.5T 自动风尚版  杭州", "car_logo_url"=>"http://assets.che300.com/theme/images/brand/large/b93.jpg"}
      rescue
        nil
      end

      def eval_price(car)
        raw_data = che3bai_estimate_price(car)
        return 0 if raw_data.blank?
        raw_data.fetch("eval_price").to_i
      end

      def dealer_buy_price(car)
        raw_data = che3bai_estimate_price(car)
        return nil if raw_data.nil?
        raw_data.fetch("dealer_buy_price")
      end
    end
  end
end
