require "rails_helper"

RSpec.describe V1::CarsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:disney) { shops(:disney) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:nolan) { users(:nolan) }
  let(:batman) { users(:batman_1) }
  let(:tiantian_clean) { cooperation_companies(:tiantian_clean) }
  let(:a_level) { warranties(:a_level) }
  let(:aodi_4s) { channels(:aodi_4s) }
  let(:aodi) { cars(:aodi) }
  let(:a4_old) { cars(:a4) }
  let(:a4_alliance_refunded) { cars(:a4_alliance_refunded) }
  let(:a4) { cars(:a4_copied) }

  let(:black) { "黑色" }
  let(:key_count) { 10_000 }
  let(:aodi_image_1) { images(:aodi_image_1) }
  let(:aodi_image_2) { images(:aodi_image_2) }
  let(:avengers) { alliances(:avengers) }

  let(:x5) { cars(:bmw_x5) }
  let(:x6) { cars(:bmw_x6) }
  let(:git) { users(:git) }
  let(:noaodi) { alliances(:noaodi) }
  let(:baoma) { alliances(:baoma) }
  let(:hydra) { alliances(:hydra) }

  before do
    login_user(zhangsan)
    allow_any_instance_of(Publisher::Che168Service).to receive(:execute).and_return("")
  end

  describe "POST /api/v1/cars" do
    before do
      give_authority(zhangsan, "车辆新增入库", "牌证信息录入")

      @create_request = lambda do
        params = ParamsBuilder.build(
          "cars/create",
          user: zhangsan,
          cooperation_company: tiantian_clean,
          warranty: a_level,
          shop: disney
        ).deep_symbolize_keys!

        auth_post :create, params.fetch(:create_parameters)

        @car = Car.find_by(vin: "abc123456")
      end

      @create_request_2 = lambda do
        params = ParamsBuilder.build(
          "cars/create_2",
          user: zhangsan,
          cooperation_company: tiantian_clean,
          warranty: a_level,
          shop: disney
        ).deep_symbolize_keys!

        auth_post :create, params.fetch(:create_parameters)

        @car2 = Car.find_by(vin: "def123456")
      end

      @create_request_no_vin = lambda do
        params = ParamsBuilder.build(
          "cars/create_no_vin",
          user: zhangsan,
          cooperation_company: tiantian_clean,
          warranty: a_level,
          shop: disney
        ).deep_symbolize_keys!

        auth_post :create, params.fetch(:create_parameters)

        @car_no_vin = Car.find_by(name: "no_vin")
      end
    end

    it "creates a car" do
      @create_request.call

      expect(@car.cover.url).to eq "aa.jpg"
      expect(@car.cover_url).to eq "aa.jpg"
      expect(@car.fee_detail).to eq "破费"
      expect(@car.acquisition_transfer.vin).to eq "abc123456"
      expect(@car.acquisition_transfer.commercial_insurance_amount_cents).to eq 500
      expect(@car.acquisition_transfer.commercial_insurance).to eq true
      expect(@car.acquisition_transfer.user_id).to eq zhangsan.id
      expect(@car.acquisition_transfer.items.include?(:commercial_insurance)).to be_truthy
      expect(@car.yellow_stock_warning_days).to eq 10
      expect(@car.manufacturer_configuration["基本参数"]).to be_present
      expect(@car.shop.id).to eq disney.id
      expect(@car.is_special_offer).to be_truthy
      expect(@car.images.last.sort).to eq 1
      expect(@car.images_count).to eq 2
      expect(@car.transmission).to eq "cvt"

      # 车辆入库时新建财务记录
      # expect(@car.finance_car_income).to be_present
      # expect(@car.finance_car_income.acquisition_price_wan).to eq 3
    end

    it "sets stock_number by rule" do
      tianche.update(
        automated_stock_number: true,
        automated_stock_number_prefix: "YC",
        automated_stock_number_start: 10_000
      )

      @create_request.call

      expect(@car.stock_number).to eq "YC10000"
    end

    it "sets stock_number by nil vin" do
      tianche.update(
        automated_stock_number: false,
        stock_number_by_vin: true
      )

      @create_request_no_vin.call

      expect(@car_no_vin.stock_number).to eq "CLK1"
    end

    it "sets stock_number by vin" do
      tianche.update(
        automated_stock_number: false,
        stock_number_by_vin: true
      )

      @create_request.call

      expect(@car.stock_number).to eq "123456"
    end

    it "sets stock_number by conflict vin" do
      tianche.update(
        automated_stock_number: false,
        stock_number_by_vin: true
      )

      @create_request.call
      @create_request_2.call

      expect(@car2.stock_number).to eq "CLK1"
    end

    it "如果vin码已存在，不能创建入库车辆" do
      aodi.update!(company: tianche)
      params = ParamsBuilder.build(
        "cars/create",
        user: zhangsan,
        cooperation_company: tiantian_clean,
        warranty: a_level,
        shop: disney
      ).deep_symbolize_keys!

      car_params = params.fetch(:create_parameters).fetch(:car).merge(vin: aodi.vin)

      expect do
        auth_post :create, params.fetch(:create_parameters).merge(car: car_params)
      end.to change { Car.count }.by(0)
    end

    it "sets data_completeness" do
      @create_request.call

      result = {
        "finished" => 1,
        "total" => 4
      }

      expect(@car.acquisition_transfer.data_completeness).to eq result
    end

    it "syncs shared attributes" do
      @create_request.call

      expect(@car.acquisition_transfer.shared_attributes)
        .to eq @car.sale_transfer.shared_attributes
    end

    it_should_behave_like "operation_record created" do
      let(:request_query) { @create_request.call }
    end
  end

  describe "PUT /api/v1/cars/:id" do
    before do
      give_authority(zhangsan, "车辆信息编辑", "牌证信息录入")
      @request_lambda = lambda do
        auth_put :update, id: aodi.id,
                          car: {
                            exterior_color: black,
                            vin: "b123456",
                            show_price_wan: nil,
                            fee_detail: "血崩",
                            manufacturer_configuration: {
                              key: "i'm a configuration."
                            },
                            name: "custom name",
                            transmission: :cvt,
                            attachments: %w(instructions maintenance_manual)
                          },
                          acquisition_transfer: {
                            key_count: 3
                          }
      end
    end

    it "如果vin码又被其他车辆占用，不能保存编辑" do
      a4_old.update!(
        company_id: tianche.id,
        vin: "abc123456",
        state: :in_hall
      )
      old_aodi_vin = "old-abc"
      aodi.update!(vin: old_aodi_vin)
      auth_put :update, id: aodi.id,
                        car: { vin: a4_old.vin }

      expect(aodi.reload.vin).to eq old_aodi_vin
    end

    it "changes name of car" do
      @request_lambda.call

      expect(aodi.reload.name).to eq "custom name"
    end

    it "changes transmission of car" do
      @request_lambda.call

      expect(aodi.reload.transmission).to eq "cvt"
    end

    it "更新车辆信息" do
      @request_lambda.call

      expect(aodi.reload.exterior_color).to eq black
      expect(aodi.fee_detail).to eq "血崩"
      expect(aodi.sale_transfer.vin).to eq "b123456"
      expect(Car.find(aodi.id).attachments.to_a).to be_present
    end

    it "不会将价格从nil变成0" do
      @request_lambda.call

      expect(aodi.reload.show_price_wan).to be_nil
    end

    it "更新车辆信息，及牌证信息" do
      auth_put :update, id: aodi.id,
                        car: { exterior_color: black },
                        acquisition_transfer: {
                          key_count: key_count,
                          current_plate_number: "Abc"
                        }

      acquisition_transfer = aodi.reload.acquisition_transfer

      expect(aodi.exterior_color).to eq black
      expect(acquisition_transfer.key_count).to eq key_count
      expect(acquisition_transfer.current_plate_number).to eq "Abc"
      expect(aodi.current_plate_number).to eq "Abc"
      expect(aodi.sale_transfer.original_plate_number).to eq "Abc"
    end

    it "删除图片" do
      aodi.images.first.update(is_cover: true)
      aodi.update(cover_url: aodi.cover.url)
      expect(aodi.images.all).not_to be_empty
      expect(aodi.images_count).to eq 1
      auth_put :update, id: aodi.id,
                        car: {
                          images_attributes: aodi.images.map do |i|
                            i.attributes.merge!(_destroy: true)
                          end
                        }
      expect(aodi.reload.cover_url).to be_nil
      expect(aodi.reload.images.all).to be_empty
      expect(aodi.reload.images_count).to eq 0
    end

    it_should_behave_like "operation_record created" do
      let(:request_query) { @request_lambda.call }
    end
  end

  describe "GET /api/v1/cars/:id/edit" do
    before do
      give_authority(zhangsan, "车辆信息编辑", "在库车辆查询", "牌证信息查看", "销售底价查看", "经理底价查看")
      travel_to Time.zone.parse("2015-01-10")
    end

    it "returns result" do
      auth_get :edit, id: aodi.id

      expect(response_json[:data][:id]).to eq aodi.id
      expect(response_json[:data][:is_special_offer]).to be_falsey
    end
  end

  describe "GET /api/v1/cars" do
    before do
      give_authority(
        zhangsan,
        "在库车辆查询", "已出库车辆查询", "牌证信息查看",
        "销售底价查看", "经理底价查看", "联盟底价查看", "整备费用查看"
      )
      travel_to Time.zone.parse("2015-01-10")
    end

    context "lists all cars" do
      it "in_stock list" do
        auth_get :index, per_page: 1000
        aodi_response = response_json[:data].select { |c| c[:id] == aodi.id }

        expect(aodi_response).to be_present
      end

      it "列表包括所有联盟和展示联盟" do
        auth_get :index, per_page: 1000
        aodi_response = response_json[:data].select { |c| c[:id] == aodi.id }
        expect(aodi_response
               .first[:alliances]
               .any? { |h| h[:name] == "复仇者联盟" }).to be_truthy
        expect(aodi_response
               .first[:all_alliances]
               .any? { |h| h[:name] == "复仇者联盟" }).to be_truthy
      end

      describe "联盟出库" do
        it "出库列表包括联盟出库车辆" do
          auth_get :out_of_stock
          a4_response = response_json[:data].select { |c| c[:id] == a4_old.id }
          expect(a4_response).to be_present
        end

        it "出库列表包括联盟退车车辆" do
          auth_get :out_of_stock
          a4_response = response_json[:data].select { |c| c[:id] == a4_alliance_refunded.id }
          expect(a4_response).to be_present
        end

        it "在库列表, 如果是联盟入库的车辆, 需要包含联盟入库记录" do
          give_authority(nolan, "在库车辆查询")
          login_user(nolan)
          auth_get :index, per_page: 1000
          a4_response = response_json[:data].select { |c| c[:id] == a4.id }
          expect(a4_response).to be_present
          expect(a4_response[0][:alliance_stock_in_inventory]).to be_present
        end
      end

      describe "出库列表" do
        it "out_of_stock list" do
          aodi.update_columns(state: :sold)
          auth_get :out_of_stock
          aodi_response = response_json[:data].select { |c| c[:id] == aodi.id }

          expect(aodi_response).to be_present
        end

        it "出库车辆查询接口 需要携带 销售过户信息" do
          aodi.update_columns(state: :sold)
          auth_get :out_of_stock
          aodi_response = response_json[:data].select { |c| c[:id] == aodi.id }
          expect(aodi_response.first).to have_key :sale_transfer
        end

        it "出库车辆查询接口 需要携带 发票费用" do
          aodi.update_columns(state: :sold)
          auth_get :out_of_stock
          aodi_response = response_json[:data].select { |c| c[:id] == aodi.id }
          expect(aodi_response.first[:stock_out_inventory]).to have_key :invoice_fee_yuan
        end
      end
    end

    context "support search" do
      it "returns result" do
        auth_get :index, per_page: 6, page: 1, query: { stock_number_eq: "abc" }

        expect(response_json[:data].size).to eq 1
      end
    end

    it "includes Link in header" do
      auth_get :index, per_page: 2, page: 2

      expect(response.header.fetch("Link")).to be_present
    end
  end

  describe "GET /api/v1/cars/:id" do
    before do
      give_authority(zhangsan, *User.authorities)
    end

    it "returns detail for car" do
      auth_get :show, id: aodi.id
      data = response_json[:data]

      expect(data[:id]).to eq aodi.id
      expect(data[:fee_detail]).to eq aodi.fee_detail
      expect(data[:prepare_record][:prepare_items].size).to be > 0
      expect(data[:stock_out_inventory][:sales_type]).to eq "retail"
    end

    it "如果是联盟出库车辆(已出库状态), 显示出库合同" do
      auth_get :show, id: a4_old.id
      expect(response_json[:data][:micro_contract]).to be_present
    end

    it "如果是销售员查看，即使没有权限，依旧显示出库合同" do
      deprive_authority(lisi, "销售成交信息查看")
      login_user(lisi)
      auth_get :show, id: a4_old.id
      expect(response_json[:data][:micro_contract]).to be_present
    end

    it "如果没有权限不显示出库合同" do
      deprive_authority(zhangsan, "销售成交信息查看")
      login_user(zhangsan)
      auth_get :show, id: a4_old.id
      expect(response_json[:data][:micro_contract]).to be_nil
    end

    it "如果是联盟入库车辆(在库状态), 显示入库合同" do
      give_authority(nolan, "收购价格查看")
      login_user(nolan)
      auth_get :show, id: a4.id
      expect(response_json[:data][:micro_contract]).to be_present
    end

    it "如果是收购员查看，没有权限也显示入库合同" do
      deprive_authority(nolan, "收购价格查看")
      login_user(nolan)
      auth_get :show, id: a4.id
      expect(response_json[:data][:micro_contract]).to be_present
    end

    it "如果没有权限不显示入库合同" do
      deprive_authority(batman, "收购价格查看")
      login_user(batman)
      auth_get :show, id: a4.id
      expect(response_json[:data][:micro_contract]).to be_nil
    end

    it "详情包括所有联盟和展示联盟" do
      auth_get :show, id: aodi.id
      expect(response_json[:data][:alliances]
             .any? { |h| h[:name] == "复仇者联盟" }).to be_truthy
      expect(response_json[:data][:all_alliances]
             .any? { |h| h[:name] == "复仇者联盟" }).to be_truthy
    end

    it "包括成本总计和成本详情-收购成本, 整备费用, 牌证过户" do
      auth_get :show, id: aodi.id
      expect(response_json[:data][:cost_sum]).to be_present
      expect(response_json[:data][:cost_statement]).to eq(
        acquisition_price: { name: "收购价", value: aodi.acquisition_price_wan, unit: "万元" },
        prepare_fee: { name: "整备费用", value: aodi.prepare_record.total_amount_yuan, unit: "元" },
        license_transfer_fee: { name: "牌证过户费用",
                                value: aodi.acquisition_transfer.total_transfer_fee_yuan,
                                unit: "元" }
      )
    end

    it "如果收购者不是本人且没有权限, 不返回成本信息" do
      login_user(lisi)
      auth_get :show, id: aodi.id
      expect(response_json[:data][:cost_sum]).not_to be_present
    end

    it "如果收购者不是本人但有权限, 返回成本信息" do
      login_user(lisi)
      give_authority(lisi, "收购价格查看")
      auth_get :show, id: aodi.id
      expect(response_json[:data][:cost_sum]).to be_present
    end
  end

  context "车辆联盟展示" do
    describe "GET /api/v1/cars/:id/alliances" do
      it "returns alliances for aodi" do
        give_authority(zhangsan, *User.authorities)
        login_user(zhangsan)

        auth_get :alliances, id: aodi.id
        # car: 奥迪 -> company: 天车 -> alliances: [复仇者联盟, 不卖奥迪的天车]
        expect(response_json[:data][:all_alliances].count)
          .to eq 2

        expect(response_json[:data][:all_alliances]
               .any? { |h| h[:name] == avengers.name }).to be_truthy
        expect(response_json[:data][:all_alliances]
               .any? { |h| h[:name] == noaodi.name }).to be_truthy

        # 黑名单: car: 奥迪 -> alliances: 不卖奥迪的天车
        expect(response_json[:data][:allowed_alliances].count).to eq 1
        expect(response_json[:data][:allowed_alliances].first[:name])
          .to eq avengers.name
      end

      it "returns alliances for x5" do
        give_authority(git, "联盟车辆查询")
        login_user(git)
        auth_get :alliances, id: x5.id
        # car: x5 -> company: github -> alliances: [木有奥迪, 宝马家族, 九头蛇]
        expect(response_json[:data][:all_alliances].count).to eq 3
        # 黑名单: car: x5 -> alliances: 九头蛇
        expect(response_json[:data][:allowed_alliances].count).to eq 2
      end

      it "returns alliances for x6" do
        give_authority(git, "联盟车辆查询")
        login_user(git)
        auth_get :alliances, id: x6.id
        # car: x6 -> company: github -> alliances: [木有奥迪, 宝马家族, 九头蛇]
        expect(response_json[:data][:all_alliances].count).to eq 3
        expect(response_json[:data][:allowed_alliances].count).to eq 3
      end
    end

    describe "PUT /api/v1/cars/:id/alliances" do
      before do
        give_authority(git, "联盟车辆查询")
        login_user(git)
      end

      it "edit alliances for car - same" do
        auth_put :update_alliances, id: x5.id,
                                    alliances: [baoma.id, noaodi.id]
        expect(response_json[:data][:allowed_alliances].count).to eq 2
      end

      it "edit alliances for car - change" do
        auth_put :update_alliances, id: x5.id,
                                    alliances: []
        expect(response_json[:data][:allowed_alliances]).to be_empty
      end

      it "edit alliances for car - nil" do
        auth_put :update_alliances, id: x5.id,
                                    alliances: nil
        expect(response_json[:data][:allowed_alliances]).to be_empty
      end
    end
  end

  describe "DELETE /api/v1/cars/:id" do
    before do
      give_authority(zhangsan, "在库车辆删除")
    end

    it "deletes a specify car" do
      auth_delete :destroy, id: aodi.id

      expect { Car.find(aodi.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST /api/v1/cars/import" do
    before do
      give_authority(zhangsan, "网站车辆导入")
    end

    it "will not be executed if the job is running" do
      RedisClient.current.incr("import_job_#{zhangsan.company_id}")
      auth_post :import, import_id: 162_336

      expect(response.status).to eq 403
    end

    it "导入车辆" do
      auth_post :import, import_id: 162_336

      expect(response_json[:data][:id]).to be_present
    end
  end

  describe "PUT /api/v1/cars/:car_id/images" do
    before do
      give_authority(zhangsan, "车辆图片上传")
    end

    it "删除图片" do
      expect(aodi.images.all).not_to be_empty
      expect(aodi.images_count).to eq 1

      images_attributes = aodi.images.map do |i|
        i.attributes.merge!(_destroy: true)
      end

      images_attributes.map { |attr| attr.except!("sort") }

      auth_put :images_update,
               car_id: aodi.id,
               car: { images_attributes: images_attributes }
      expect(aodi.reload.images.all).to be_empty
      expect(aodi.reload.images_count).to eq 0
    end
  end

  describe "GET /api/v1/cars/:car_id/images_download" do
    it "打包牌证下载图片" do
      VCR.use_cassette("img_download") do
        auth_get :images_download, car_id: aodi.id
      end
      expect(response.content_type).to eq "application/zip"
    end

    it "打包车辆下载图片" do
      VCR.use_cassette("img_download") do
        auth_get :images_download, car_id: aodi.id, download_type: "car"
      end
      expect(response.content_type).to eq "application/zip"
    end
  end

  describe "GET /api/v1/cars/import_search" do
    before do
      give_authority(zhangsan, "网站车辆导入")
    end

    it "搜索che168商家 车来车往" do
      VCR.use_cassette("import_search") do
        auth_get :import_search, company_name: "车来车往"
      end

      expect(response_json[:data].first[:id]).to eq 70_514
    end

    it "搜索 che168 新东昇" do
      VCR.use_cassette("import_search_xindongsheng") do
        auth_get :import_search, company_name: "新东昇"
      end

      expect(response_json[:data].first[:id]).to eq 119_771
    end
  end

  describe "GET /api/v1/cars/brands" do
    it "lists all brands in this company" do
      auth_get :brands
      brands_size = tianche.cars.select(:brand_name).distinct.count

      expect(response_json[:data].size).to eq brands_size
    end
  end

  describe "GET /api/v1/cars/series" do
    it "lists all series in this company" do
      VCR.use_cassette("company_series") do
        auth_get :series, brand: { name: "奥迪" }
      end

      series_size = tianche.cars.select(:series_name).distinct.count
      response_size = 0

      response_json[:data].each do |series|
        response_size += series[:series].size
      end
      expect(response_size).to eq series_size
    end
  end

  describe "GET /api/v1/cars/acquirers" do
    it "lists all acquirers by cars" do
      auth_get :acquirers

      expect(response_json[:data]).to be_present
    end

    it "filters by state_type" do
      auth_get :acquirers, state_type: :in_stock

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/cars/sellers" do
    before do
      aodi.update_columns(state: :sold)
    end

    it "lists all sellers by stock out inventories" do
      auth_get :sellers

      expect(response_json[:data]).to be_present
    end
  end

  describe "GET /api/v1/cars/:id/qrcode" do
    it "微信授权取消，应该去调用友好速达的接口" do
      google = "http://www.google.com"

      allow(Wechat::Mp::Qrcode).to receive(:generate).and_raise(Wechat::Error::Unauthenticated.new)
      allow(Util::QRCode).to receive(:youhaosuda_url).and_return(google)

      get :qrcode, id: aodi.id

      expect(response).to be_present
    end
  end

  describe "GET /api/v1/cars/:id/meta_info" do
    it "返回车辆状态值" do
      auth_get :meta_info, id: aodi.id

      expect(response_json[:data][:state]).to eq "preparing"
      expect(response_json[:data][:allied]).to be_falsey
      expect(response_json[:data][:in_same_own_brand_alliance]).to be_truthy
    end
  end

  describe "GET /api/v1/cars/:id/alliance_similar" do
    it "返回联盟内相似车辆" do
      auth_get :alliance_similar, id: aodi.id

      expect(response.status).to eq 200
    end
  end

  describe "GET /api/v1/cars/:id/similar" do
    it "返回公司内相似车辆" do
      auth_get :similar, id: aodi.id

      expect(response_json[:data]).to be_present
    end
  end

  describe "PATCH /api/v1/cars/:id/viewed" do
    it "update the viewed_count of car" do
      expect do
        auth_get :viewed, id: aodi.id
      end.to change { aodi.reload.viewed_count }.by(1)
    end
  end

  describe "GET multi_images_share" do
    it "得到车辆二维码及具体的短链"
  end

  describe "GET shared_url" do
    it "得到分享出去的车辆详情页地址" do
      allow_any_instance_of(Car::WeshopService).to receive(:youhaosuda_company_domain)
        .and_return([true, "http://domain"])
      auth_get :shared_url, id: aodi
      expect(response_json).to be_present
    end
  end

  describe "GET shared_car_list" do
    it "得到新官网车辆列表列表页地址" do
      auth_get :shared_car_list, query: "{\"brand_name_eq\":\"标致\",\"series_name_eq\":\"标致408\"}"

      expect(response_json).to be_present
    end
  end

  describe "GET check_vin" do
    it "本公司里未有相同vin码,返回true" do
      aodi.save
      auth_get :check_vin, vin: "asdfasdf"
      expect(response_json[:data][:status]).to be_truthy
    end

    it "本公司已有相同vin码的车辆，返回false" do
      aodi.save
      auth_get :check_vin, vin: aodi.vin
      expect(response_json[:data][:status]).to be_falsey
    end
  end

  describe "PUT onsale" do
    before do
      give_authority(zhangsan, "车辆销售定价")
    end

    context "设置为特卖" do
      it "更改属性" do
        auth_put :onsale,
                 id: aodi.id,
                 is_onsale: true, onsale_price_wan: 12,
                 onsale_description: "新设置为特卖车"

        aodi.reload
        expect(aodi.is_onsale).to be_truthy
        expect(aodi.onsale_price_wan).to eq 12
      end
    end

    context "取消特卖" do
      it "相应值设置为空" do
        aodi.update!(is_onsale: true, onsale_price_wan: 11, onsale_description: "this is text")
        auth_put :onsale,
                 id: aodi.id,
                 is_onsale: false

        expect(aodi.reload.is_onsale).to be_falsey
      end
    end
  end
end
