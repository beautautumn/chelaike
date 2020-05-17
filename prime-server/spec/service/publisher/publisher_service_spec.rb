require "rails_helper"

if ENV.key?("LOCAL_TEST")

  RSpec.describe Publisher::PublishService do
    fixtures :cars, :users, :companies

    let(:aodi) { cars(:aodi) }
    let(:zhangsan) { users(:zhangsan) }

    let(:github) { companies(:github) }
    let(:git) { users(:git) }

    # let(:platform) { :che168 }
    # let(:platform) { :yiche }
    let(:platform) { :com58 }
    let(:publish_service) { Publisher::PublishService.new(git.id, platform) }

    before do
      WebMock.allow_net_connect!
    end

    after do
      WebMock.allow_net_connect!
    end

    def bind_all_platform
      github.create_platform_profile(data: yiche_profile.merge(che168_profile).merge(com58_profile))
    end

    describe "#validate_missings" do
      it "returns the missings for the platform" do
        bind_all_platform

        VCR.turned_off do
          result = publish_service.validate_missings(aodi)
          expect(result).to be_present
        end
      end
    end

    describe "#brands" do
      it "returns the brands based on the platform" do
        bind_all_platform

        VCR.turned_off do
          brands = publish_service.brands
          expect(brands).to be_present
        end
      end
    end

    describe "#create(car_id, extra_attrs)" do
      def images_attrs
        {
          image_urls: [
            "http://image.chelaike.com/images/1e91bccbb34d05a4bc8662d995909c33.jpg",
            "http://image.chelaike.com/images/dc2ff46eaa3c924db383f8ce17389157.jpg",
            "http://image.chelaike.com/images/c43ae0168b3f93973df8a04fbf454394.jpg",
            "http://image.chelaike.com/images/2e2672306a616e8b6a9ea48891b1a61e.jpg"],
          annual_inspection_end_at: "2016-12-09",
          driver_image_url: "http://image.chelaike.com/images/2e2672306a616e8b6a9ea48891b1a61e.jpg"
        }
      end

      def yiche_extra_attrs
        { # vin: "WVWR23136CV026699",
          brand_name_id: "84",
          series_name_id: "2959",
          style_name_id: "117253"
        }.merge(image_urls)
      end

      def che168_extra_attrs
        { "brand_name_id" => "14",
          "series_name_id" => "78",
          "style_name_id" => "6383",
          "car_use" => 1,
          "with_transfer_fee" => 0,
          "annual_inspection_end_at" => Time.zone.today,
          "compulsory_insurance_end_at" => 1.year.since
        }.merge(images_attrs)
      end

      def com58_extra_attrs
        {
          "guarantee_service" => "有保障服务",
          "style_name_id" => "2007款 2.0 自动 标准版",
          "series_name_id" => "雅阁",
          "brand_name_id" => "本田"
        }.merge(images_attrs)
      end

      def yiche_contact_value
        "265875"
      end

      def che168_contact_value
        "129132"
      end

      def com58_contact_value
        zhangsan.id
      end

      def yiche_car
        aodi.update_columns(
          vin: "",
          mileage: 5,
          mileage_in_fact: 5.6,
          licensed_at: 6.years.ago
        )
        aodi
      end

      def che168_car
        aodi.update_columns(
          brand_name: "本田",
          series_name: "雅阁",
          style_name: "款 2.0L EX Navi",
          show_price_cents: 8_800_000,
          mileage: 7,
          licensed_at: Time.zone.parse("2009-05-01"),
          exterior_color: "白色",
          transmission: "auto",
          selling_point: "good"
        )
        aodi
      end

      def com58_car
        aodi.update_columns(
          vin: "WVWR23136CV026699",
          brand_name: "本田",
          series_name: "雅阁",
          style_name: "2007款 2.0L 自动标准版",
          show_price_cents: 8_800_000,
          mileage: 7,
          licensed_at: Time.zone.parse("2009-05-01"),
          exterior_color: "白色",
          transmission: "auto",
          selling_point: "一级棒！！！！！！！！！！！"
        )
        aodi
      end

      it "creates a new publish_record for the car" do
        bind_all_platform

        car = send("#{platform}_car")
        VCR.turned_off do
          # result = publish_service.validate_missings(car)

          publish_service.create(
            car.id,
            send("#{platform}_extra_attrs"),
            send("#{platform}_contact_value")
          )

          state = car.send("publish_#{platform}_record").state
          expect(state).to eq "finished"
        end
      end

      it "publishes the car to the platform" do
        yiche = Publisher::PublishService.new(git.id, platform)

        VCR.turned_off do
          yiche.create(aodi.car_id, extra_attrs, "张小姐")
        end
      end
    end
  end
end
