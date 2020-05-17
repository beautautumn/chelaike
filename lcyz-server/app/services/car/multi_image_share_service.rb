class Car < ActiveRecord::Base
  class MultiImageShareService
    attr_accessor :car

    def initialize(user, car)
      @user = user
      @car = car
    end

    def execute
      shared_url = Car::WeshopService.new(@car).shared_detail_url(@user.id)

      short_url = generate_short_link(shared_url)

      qrcode_url = upload_qrcode(shared_url)

      {
        image_urls: image_urls(qrcode_url),
        car_basics: car_basics(short_url)
      }
    end

    private

    def upload_qrcode(url)
      io_stream = StringIO.new(generate_qrcode(url).to_s)
      Util::AliyunOssNew.new("QRCODE-#{SecureRandom.hex}.jpg").upload(io_stream.read)
    end

    def generate_qrcode(url)
      qrcode = RQRCode::QRCode.new(url)
      qrcode.as_png(size: 300)
    end

    def generate_short_link(url)
      short_url = Shortener::ShortenedUrl.generate(url, owner: @car)
      Rails.application.routes.url_helpers.url_for(
        controller: :"shortener/shortened_urls",
        action: :show,
        id: short_url.unique_key,
        only_path: false,
        host: ENV["SERVER_HOST"]
      )
    end

    def image_urls(qrcode_url)
      car_images = @car.images.map(&:url)
      images_count = car_images.count
      case
      when images_count < 5
        car_images << qrcode_url
      when images_count >= 5
        car_images.insert(4, qrcode_url)
      end
    end

    def car_basics(short_url)
      {
        company_name: shop_name,
        system_name: @car.system_name,
        licensed_at: licensed_at_text,
        mileage: @car.mileage,
        car_price: car_price,
        selling_point: @car.selling_point,
        mortgage_note: @car.mortgage_note,
        seller_name: @user.name,
        seller_phone: @user.phone,
        company_address: @user.shop.try(:address) || @user.company.try(:address),
        detail_url: short_url
      }
    end

    def shop_name
      @user.shop.try(:name) || @user.company.try(:name)
    end

    def licensed_at_text
      case @car.license_info.to_s
      when "licensed"
        @car.licensed_at.try(:strftime, "%Y年%m月")
      when "unlicensed"
        "未上牌"
      when "new_car"
        "新车"
      end
    end

    def show_new_car_price?
      @car.new_car_guide_price_cents && @car.new_car_final_price_cents
    end

    def show_save_price?
      @car.show_price_wan && show_new_car_price?
    end

    def new_car_price_text
      return unless show_new_car_price?
      new_car_price = @car.new_car_guide_price_wan
      buy_tax = (@car.new_car_final_price_wan - @car.new_car_guide_price_wan).round(2)
      "新车价格：#{new_car_price}万 + #{buy_tax}万(购置税)"
    end

    def save_price_text
      return unless show_save_price?
      save_price = (@car.new_car_final_price_wan - @car.show_price_wan).round(2)
      "省#{save_price}万"
    end

    def car_price
      price_text = if @car.show_price_wan.present?
                     "#{@car.show_price_wan}万"
                   else
                     "即将开售"
                   end

      [price_text, new_car_price_text, save_price_text].compact.join("，")
    end
  end
end
