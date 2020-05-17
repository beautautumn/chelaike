# == Schema Information
#
# Table name: cars # 车辆
#
#  id                             :integer          not null, primary key    # 车辆
#  company_id                     :integer
#  shop_id                        :integer
#  acquirer_id                    :integer                                   # 收购员
#  acquired_at                    :datetime                                  # 收购日期
#  channel_id                     :integer                                   # 收购渠道
#  acquisition_type               :string                                    # 收购类型
#  acquisition_price_cents        :integer                                   # 收购价
#  stock_number                   :string                                    # 库存编号
#  vin                            :string                                    # 车架号
#  state                          :string                                    # 车辆状态
#  state_note                     :string                                    # 车辆备注
#  brand_name                     :string                                    # 品牌名称
#  manufacturer_name              :string                                    # 厂商名称
#  series_name                    :string                                    # 车系名称
#  style_name                     :string                                    # 车型名称
#  car_type                       :string                                    # 车辆类型
#  door_count                     :integer                                   # 门数
#  displacement                   :float                                     # 排气量
#  fuel_type                      :string                                    # 燃油类型
#  is_turbo_charger               :boolean                                   # 涡轮增压
#  transmission                   :string                                    # 变速箱
#  exterior_color                 :string                                    # 外饰颜色
#  interior_color                 :string                                    # 内饰颜色
#  mileage                        :float                                     # 表显里程(万公里)
#  mileage_in_fact                :float                                     # 实际里程(万公里)
#  emission_standard              :string                                    # 排放标准
#  license_info                   :string                                    # 牌证信息
#  licensed_at                    :date                                      # 首次上牌日期
#  manufactured_at                :date                                      # 出厂日期
#  show_price_cents               :integer                                   # 展厅价格
#  online_price_cents             :integer                                   # 网络标价
#  sales_minimun_price_cents      :integer                                   # 销售底价
#  manager_price_cents            :integer                                   # 经理价
#  alliance_minimun_price_cents   :integer                                   # 联盟底价
#  new_car_guide_price_cents      :integer                                   # 新车指导价
#  new_car_additional_price_cents :integer                                   # 新车加价
#  new_car_discount               :float                                     # 新车优惠折扣
#  new_car_final_price_cents      :integer                                   # 新车完税价
#  interior_note                  :text                                      # 车辆内部描述
#  star_rating                    :integer                                   # 车辆星级
#  warranty_id                    :integer                                   # 质保等级
#  warranty_fee_cents             :integer                                   # 质保费用
#  is_fixed_price                 :boolean                                   # 是否一口价
#  allowed_mortgage               :boolean                                   # 是否可按揭
#  mortgage_note                  :text                                      # 按揭说明
#  selling_point                  :text                                      # 卖点描述
#  maintain_mileage               :float                                     # 保养里程
#  has_maintain_history           :boolean                                   # 有无保养记录
#  new_car_warranty               :string                                    # 新车质保
#  standard_equipment             :text             default([]), is an Array # 厂家标准配置
#  personal_equipment             :text             default([]), is an Array # 车主个性配置
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  stock_age_days                 :integer          default(0)               # 库龄
#  age                            :integer                                   # 车龄
#  sellable                       :boolean          default(TRUE)            # 是否可售
#  states_statistic               :jsonb                                     # 状态统计
#  state_changed_at               :datetime                                  # 状态修改时间
#  yellow_stock_warning_days      :integer          default(30)              # 库存预警
#  imported                       :string
#  reserved_at                    :datetime                                  # 预约时间
#  consignor_name                 :string                                    # 寄卖人
#  consignor_phone                :string                                    # 寄卖人电话
#  consignor_price_cents          :integer                                   # 寄卖价格
#  deleted_at                     :datetime                                  # 删除时间
#  stock_out_at                   :datetime                                  # 出库时间
#  closing_cost_cents             :integer                                   # 成交价格
#  manufacturer_configuration     :hstore
#  predicted_restocked_at         :datetime                                  # 预计回厅时间
#  reserved                       :boolean          default(FALSE)           # 是否已经预定
#  configuration_note             :text                                      # 车型配置描述
#  name                           :string                                    # 车辆名称
#  name_pinyin                    :string                                    # 车辆名称拼音
#  attachments                    :string           default([]), is an Array # 车辆附件
#  red_stock_warning_days         :integer          default(45)              # 红色预警
#  level                          :string                                    # 车辆等级
#  current_plate_number           :string                                    # 现车牌(冗余牌证表)
#  system_name                    :string                                    # 车辆系统名
#  is_special_offer               :boolean          default(FALSE)           # 是否特价
#  estimated_gross_profit_cents   :integer                                   # 预期毛利
#  estimated_gross_profit_rate    :float                                     # 预期毛利率
#  fee_detail                     :text                                      # 费用情况
#  current_publish_records_count  :integer          default(0), not null
#  images_count                   :integer          default(0)               # 图片数量
#  seller_id                      :integer                                   # 成交员工
#  cover_url                      :string                                    # 车辆封面图
#  alliance_cover_url             :string                                    # 联盟封面图
#  is_onsale                      :boolean          default(FALSE)           # 车辆是否特卖
#  onsale_price_cents             :integer                                   # 特卖价格
#  onsale_description             :string                                    # 特卖描述
#  owner_company_id               :integer                                   # 归属车商公司ID
#

require "rails_helper"

RSpec.describe Car, type: :model do
  fixtures :all

  let(:aodi) { cars(:aodi) }
  let(:a4) { cars(:a4_copied) }
  let(:a4_old) { cars(:a4) }
  let(:disney) { shops(:disney) }
  let(:tumbler) { cars(:tumbler) }

  describe ".count_stock_age_days" do
    before do
      travel_to Time.zone.parse("2015-01-10")
      aodi.update_columns(created_at: Time.zone.now.beginning_of_day)
    end

    context "counts stock_age_days for a car" do
      it "returns 1 for today's car" do
        travel_to Time.zone.now.beginning_of_day + 2.hours

        expect(aodi.send(:count_stock_age_days)).to eq 9
      end

      it "returns 2 for yesterday's car" do
        travel_to Time.zone.now.beginning_of_day + 2.hours + 1.day

        expect(aodi.send(:count_stock_age_days)).to eq 10
      end
    end
  end

  describe ".count_age" do
    before do
      aodi.update_columns(licensed_at: Time.zone.today - 100.days)
    end

    it "returns 100 for car age" do
      expect(aodi.send(:count_age)).to eq 100
    end
  end

  describe ".actual_states_statistic" do
    before do
      travel_to Time.zone.parse("2015-01-14")
    end

    it "returns states statistic" do
      states_statistic = {
        "in_hall" => 3,
        "preparing" => 5,
        "shipping" => 3,
        "driven_back" => 2
      }

      expect(aodi.count_states_statistic).to eq states_statistic
    end

    it "returns stock_age_days for current state" do
      states_statistic = {
        "in_hall" => 13
      }

      expect(Car.last.count_states_statistic).to eq states_statistic
    end
  end

  describe ".syncs_shop_id" do
    it "syncs shop_id after changed" do
      aodi.update_columns(shop_id: nil)
      expect(aodi.reload.car_reservation.shop_id).not_to be_present

      aodi.update(shop_id: disney.id)
      expect(aodi.reload.car_reservation.shop_id).to be_present
    end
  end

  describe "#clean_licensed_at" do
    it "cleans licensed_at unless licensed" do
      expect do
        aodi.update(license_info: "unlicensed")
      end.to change { aodi.licensed_at }.from(Date.new(2015, 1, 1)).to(nil)
    end
  end

  describe "#make_system_name" do
    context "there's blank element of the 3 elements" do
      it "rejects the blank element" do
        car_params = {
          brand_name:  "讴歌",
          series_name: "MDX",
          style_name:  ""
        }

        expect(Car.new(car_params).make_system_name).to eq "讴歌 MDX"
      end
    end

    context "no blank element" do
      it "contains all the three elements" do
        car_params = {
          brand_name:  "讴歌",
          series_name: "MDX",
          style_name:  "2016"
        }

        expect(Car.new(car_params).make_system_name).to eq "讴歌 MDX 2016"
      end
    end

    context "series_name starts with the brand_name" do
      it "does not contain the brand_name" do
        car_params = {
          brand_name:  "奥迪",
          series_name: "奥迪A4L",
          style_name:  "1.8T 手动"
        }

        new_car = Car.new(car_params)
        expect(new_car.make_system_name).to eq "奥迪A4L 1.8T 手动"
        expect(new_car.brand_name).to eq "奥迪"
      end
    end
  end

  def images_params
    [
      {
        url: "aa.jpg",
        location: "xxx",
        is_cover: true,
        sort: 0
      },
      {
        url: "xxx.avi",
        location: "xxx",
        is_cover: false,
        sort: 1
      }
    ]
  end

  describe "#alliance_cover_url" do
    it "得到联盟图的封面图" do
      aodi.update(alliance_images_attributes: images_params)
      expect(aodi.alliance_cover_url).to eq "aa.jpg"
    end
  end

  describe "#current_publish_records_count" do
    it "update正确的设置current_publish_records_count" do
      publish_record = aodi.car_publish_records.first

      expect(aodi.current_publish_records_count).to eq 0
      publish_record.update(current: true)
      expect(aodi.reload.current_publish_records_count).to eq 1
    end

    it "create正确的设置current_publish_records_count" do
      expect(aodi.current_publish_records_count).to eq 0
      aodi.car_publish_records.create(current: true)
      expect(aodi.reload.current_publish_records_count).to eq 1
    end

    it "destory正确的设置current_publish_records_count" do
      aodi.car_publish_records.create(current: true)
      expect(aodi.reload.current_publish_records_count).to eq 1
      aodi.car_publish_records.destroy_all
      expect(aodi.reload.current_publish_records_count).to eq 0
    end
  end

  describe "#cost_sum" do
    it "gets cost sum" do
      expect(aodi.cost_sum).to eq 30180
    end

    it "gets cost sum wan" do
      expect(aodi.cost_sum_wan).to eq 3.02
    end
  end

  describe "联盟出库 & 退车" do
    it "联盟出库" do
      expect(aodi.alliance_stocked_out?).to be_falsy
      aodi.alliance_stock_out
      expect(aodi.alliance_stocked_out?).to be_truthy
    end

    it "联盟退车" do
      expect(a4.acquired_from_alliance?).to be_truthy
      expect(a4.alliance_stock_in_inventory).to be_present
      a4.alliance_refund!
      expect(a4.alliance_refunded?).to be_truthy
    end

    it "联盟回库" do
      expect(a4_old.alliance_stocked_out?).to be_truthy
      expect(a4_old.alliance_stock_out_inventory).to be_present
      a4_old.alliance_stock_back!
      expect(a4_old.in_hall?).to be_truthy
    end
  end

  describe "#stock_dates" do
    it "validates stock dates" do
      expect do
        aodi.update!(acquired_at: Date.new(2017, 1, 1))
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe "#find_or_create_finance_car_income" do
    it "有财务记录则返回" do
      expect(tumbler.find_or_create_finance_car_income).to be_present
    end

    it "财务记录为空则创建" do
      expect(aodi.finance_car_income).to be_nil
      aodi.find_or_create_finance_car_income
      expect(aodi.reload.finance_car_income).to be_present
    end
  end

  describe ".upcase vin" do
    it "保存时把vin码大写" do
      aodi.vin = "asdf1234"
      aodi.save!
      expect(aodi.reload.vin).to eq "ASDF1234"
    end
  end
end
