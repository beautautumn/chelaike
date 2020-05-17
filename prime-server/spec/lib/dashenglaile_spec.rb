require "rails_helper"
if ENV.key?("LOCAL_TEST")
  RSpec.describe Dashenglaile do
    before do
      WebMock.allow_net_connect!
      VCR.turn_off!
    end

    describe "Brand.get" do
      it "gets brands list" do
        expect(Dashenglaile::Brand.get).not_to be_nil
      end
    end

    describe "Brand.brand_info" do
      it "gets brands info" do
        expect(
          Dashenglaile::Brand.brand_info("LBVCU3109DSG28165")["brand_name"]
        ).to eq "宝马"
      end
    end

    describe "Brand.brand_price" do
      it "gets brands price" do
        expect(
          Dashenglaile::Brand.brand_price
        ).to eq 29
      end
    end

    describe "Brand.working_hours" do
      it "gets working hours" do
        expect(
          Dashenglaile::Brand.working_hours(brand_id: 17)
        ).to eq [{ hour: 9, min: 0 }, { hour: 20, min: 0 }]
      end

      it "raise error when brand is deleted by idiots" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_nil_brand") do
          expect do
            Dashenglaile::Brand.working_hours(brand_id: 16)
          end.to raise_error Dashenglaile::Error::Request
        end
      end
    end

    describe "Record.query" do
      it "create query request" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_create_query") do
          expect(Dashenglaile::Record.query(
                   brand_id: 17,
                   vin: "LBVCU3109DSG28165",
                   order_id: 1
          )).to be_truthy
        end
      end

      it "create query request without brand id" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_create_query_without_brand_id") do
          expect(Dashenglaile::Record.query(
                   vin: "LBVCU3109DSG28165",
                   order_id: 2
          )).to be_truthy
        end
      end

      it "create query request with invalid vin" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_create_query_with_invalid_vin") do
          expect do
            Dashenglaile::Record.query(
              vin: "LBVCU3109DSG2816",
              order_id: 3
            )
          end.to raise_error Dashenglaile::Error::Vin
        end
      end

      it "create query request with unknown vin" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_create_query_with_unknown_vin") do
          expect do
            Dashenglaile::Record.query(
              vin: "suxkroc53eoh22626",
              order_id: 4
            )
          end.to raise_error Dashenglaile::Error::Vin
        end
      end

      it "gets test result" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_get_test_report") do
          expect(Dashenglaile::Record.test_report(
                   order_id: 1, is_text: 1
          )).not_to be_nil
        end
      end

      it "gets generating result" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_get_report") do
          expect do
            Dashenglaile::Record.report(order_id: 1)
          end.to raise_error Dashenglaile::Error::Vin # 如果是 V3 则是 Buy
        end
      end

      it "gets html result" do
        VCR.turn_on!
        VCR.use_cassette("dasheng_get_report_html") do
          expect(Dashenglaile::Record.report(order_id: 5)).not_to be_nil
        end
      end
    end

    describe "Token.get" do
      it "gets token balance" do
        expect(Dashenglaile::Token.get).not_to be_nil
      end
    end
  end
end
