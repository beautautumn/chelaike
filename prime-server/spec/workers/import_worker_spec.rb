require "rails_helper"

RSpec.describe "车辆导入任务" do
  fixtures :users, :companies

  let(:nolan) { users(:nolan) }

  def mock_car_links(link_id)
    import_service = Car::ImportService.new(nolan)
    real_car_links = import_service.car_links(link_id)
    allow_any_instance_of(Car::ImportService).to receive_messages(
      car_links: Array(real_car_links.first)
    )
  end

  it "抓取che168.com网站非vip客户的车辆" do
    worker = ImportWorker.new
    url = "http://2sc0.autoimg.cn/usedcar/2scimg/2015/7/28/f_b_4747962874843604394.jpg"

    oss = class_double(AliyunOss).as_stubbed_const
    allow(oss).to receive(:put).and_return(url)

    link_id = 75_870 # 这个值还不能随便换哦

    VCR.use_cassette("car_img") do
      mock_car_links(link_id)
      worker.perform(nolan.id, link_id, "import_job_#{link_id}")
    end

    expect(Car.count).to eq 1
  end

  it "抓取che168.com网站vip客户的车辆" do
    worker = ImportWorker.new
    url = "http://2sc0.autoimg.cn/usedcar/2scimg/2015/7/28/f_b_4747962874843604394.jpg"

    oss = class_double(AliyunOss).as_stubbed_const
    allow(oss).to receive(:put).and_return(url)

    link_id = 162_336 # 这个值还不能随便换哦

    VCR.use_cassette("vip_car_img") do
      mock_car_links(link_id)
      worker.perform(nolan.id, link_id, "import_job_#{link_id}")
    end

    expect(Car.count).to eq 1
  end
end
