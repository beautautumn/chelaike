require "rails_helper"

RSpec.describe Car::ImportService do
  fixtures :users, :companies

  let(:zhangsan) { users(:zhangsan) }
  let(:service) { Car::ImportService.new(zhangsan) }

  before do
    login_user(zhangsan)
  end

  # fixtures里的car_img 测试数据里有16辆车
  describe "#car_links(link_id)" do
    it "returns an array with car links" do
      service = Car::ImportService.new(User.new)

      link_id = 75_870 # 这个值还不能随便换哦

      VCR.use_cassette("car_img") do
        car_links = service.car_links(link_id)
        expect(car_links).to be_present
      end
    end
  end

  def car_detail_page_parse
    VCR.use_cassette("import_car_detail") do
      service.data_parse("http://www.che168.com/dealer/75870/9619517.html")
    end
  end

  describe "#data_parse(link)" do
    it "returns car_params and acquisition_transfer_params" do
      data_params = car_detail_page_parse

      expect(data_params.keys).to match_array [:car_params, :acquisition_transfer_params]
    end
  end

  def filtered_params
    url = "http://2sc0.autoimg.cn/usedcar/2scimg/2015/7/28/f_b_4747962874843604394.jpg"

    oss = class_double(AliyunOss).as_stubbed_const
    allow(oss).to receive(:put).and_return(url)

    service.data_filter(car_detail_page_parse)
  end

  describe "#data_filter(car_params)" do
    it "returns filtered car_params" do
      result = filtered_params
      expect(result.keys).to match_array([:car_params, :acquisition_transfer_params])
      expect(result[:car_params].keys).to include(:images_attributes)
    end
  end

  describe "#execute(car_params)" do
    it "saves the car and acquisition_transfer_params to DB" do
      Car::ImportService.new(current_user).execute(filtered_params)
      expect(Car.count).to eq 1
      car = Car.first
      expect(TransferRecord.count).to eq 2

      acquisition_transfer = TransferRecord.where(transfer_record_type: "acquisition").first
      sale_transfer = TransferRecord.where(transfer_record_type: "sale").first

      expect(acquisition_transfer.car).to eq car
      expect(sale_transfer.car).to eq car
    end
  end
end
