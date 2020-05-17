require "rails_helper"

RSpec.describe V1::OldDriverController do
  fixtures :all

  describe "#notify" do
    it "得到老司机异步通知内容" do
      post :notify, "OrderID" => 2174,
                    "Status" => "1",
                    "Make" => "2014 东风悦达起亚 福瑞迪",
                    "Msg" => "",
                    "Insurance" => [{ "StartDate" => "2015-02", "EndDate" => "2018-02" }],
                    "Claims" => [
                      {
                        "ClaimDate" => "2016-07-11",
                        "Owner" => "车主 A",
                        "Plate" => "车牌 A",
                        "Description" => "追尾三者车，均损，无人伤，提醒报警，现场，商交关联   三者车：不详",
                        "TotalFee" => 2100.0,
                        "LaborFee" => 0.0,
                        "RepairDetail" => "喷漆:后保险杠皮",
                        "MaterialFee" => 0.0,
                        "Material" => {} },
                      {
                        "ClaimDate" => "2016-07-11",
                        "Owner" => "车主 A",
                        "Plate" => "车牌 A",
                        "Description" => "追尾三者车，均损，无人伤，提醒报警，现场，三者车：不详。",
                        "TotalFee" => 657.0,
                        "LaborFee" => 0.0,
                        "RepairDetail" => "",
                        "MaterialFee" => 0.0,
                        "Material" => {} },
                      {
                        "ClaimDate" => "2016-05-04",
                        "Owner" => "车主 A",
                        "Plate" => "车牌 A",
                        "Description" => "追尾三者丰田 均损 无人伤无他损 提醒报警 现场 商交关联",
                        "TotalFee" => 600.0,
                        "LaborFee" => 0.0,
                        "RepairDetail" => "低碳:前保险杠皮外修，拆装:前雾灯（右），低碳:前大灯（右）外修，喷漆:前保险杠皮",
                        "MaterialFee" => 0.0,
                        "Material" => {} }
                    ],
                    "controller" => "v1/old_driver",
                    "action" => "notify"
      expect(response.status).to eq 200
    end
  end
end
