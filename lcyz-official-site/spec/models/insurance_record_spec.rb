# frozen_string_literal: true
# == Schema Information
#
# Table name: insurance_records # 保险理赔记录
#
#  id                    :integer          not null, primary key
#  vin                   :string                                 # vin码
#  mileage               :string                                 # 里程数
#  total_records_count   :integer                                # 总记录数
#  claims_count          :integer                                # 事故次数
#  record_abstract       :jsonb                                  # 记录摘要
#  claims_abstract       :jsonb                                  # 出险事故摘要
#  claims_total_fee_yuan :decimal(12, 2)   default(0.0)          # 事故总损失元
#  claims_details        :jsonb                                  # 事故详细记录
#  car_id                :integer                                # 报告对应的car_id
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  make                  :string                                 # 车型信息
#  order_id              :string                                 # 查询报告ID
#  engine_num            :string                                 # 发动机号
#  license_no            :string                                 # 车牌号
#

require "rails_helper"

RSpec.describe InsuranceRecord, type: :model do
  # rubocop:disable Style/HashSyntax, Style/SpaceAroundOperators, Style/SpaceInsideHashLiteralBraces, Metrics/LineLength
  def response_data
    {
      :vin=>"LHGGJ5654E2078729",
      :order_id=>"6631",
      :engine_num=>"",
      :license_no=>"",
      :id_numbers=>nil,
      :make=>"2014 广汽本田 凌派",
      :insurance=>[{:EndDate=>"2018-02", :StartDate=>"2017-02"}, {:EndDate=>"2017-01", :StartDate=>"2015-01"}],
      :claims=>[
        {:Owner=>"车主 A", :Plate=>"车牌 A", :LaborFee=>2574.0, :Material=>{}, :TotalFee=>2574.0, :ClaimDate=>"2016-08-17", :Description=>"单方事故,行驶受损-直行-撞其他,本车车损 护栏", :MaterialFee=>0.0, :RepairDetail=>"前保险杠(全喷)，前保险杠修复(大)，左前叶子板(全喷)，左前叶子板整形修复(大)，左前门(全喷)，左前车门整形修复(大)，左后门(全喷)，左后车门整形修复(大)，左后叶子板(全喷)，左后叶子板整形修复(大)，后保险杠(全喷)，后保险杠修复(大)"},
        {:Owner=>"车主 A", :Plate=>"车牌 A", :LaborFee=>706.0, :Material=>{}, :TotalFee=>706.0, :ClaimDate=>"2016-03-05", :Description=>"多方事故,三者车牌：新M-8G911,行驶受损-直行-与机动车撞,本车车损 、三者车损", :MaterialFee=>0.0, :RepairDetail=>"前保险杠修复(大)，前保险杠(全喷)，前保险杠拆装(含附件)"},
        {:Owner=>"车主 A", :Plate=>"车牌 A", :LaborFee=>539.0, :Material=>{:外尾灯（右）=>1}, :TotalFee=>1548.0, :ClaimDate=>"2016-01-27", :Description=>"单方事故,行驶受损-倒车-撞其他,本车车损 垃圾箱", :MaterialFee=>1009.0, :RepairDetail=>"右后叶子板(全喷)，右后叶子板整形修复(大)，后保险杠拆装(含附件)"},
        {:Owner=>"车主 A", :Plate=>"车牌 A", :LaborFee=>0.0, :Material=>{}, :TotalFee=>0.0, :ClaimDate=>"2015-06-10", :Description=>"单方事故,玻璃单独损坏-非天窗玻璃,本车车损 停放", :MaterialFee=>0.0, :RepairDetail=>""}
      ],
      :created_at=>"2017-05-03T18:10:42.890+08:00",
      :updated_at=>"2017-05-03T18:31:39.396+08:00"
    }
  end

  describe ".initialize_with_result" do
    it "根据从车来客得到的返回数据初始化一条数据" do
      record = InsuranceRecord.initialize_with_result(1, response_data)
      expect(record.claims_details).to be_present
    end
  end
end
