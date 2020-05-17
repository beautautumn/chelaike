require "rails_helper"

RSpec.describe V1::CustomersController do
  fixtures :all

  let(:nolan) { users(:nolan) }
  let(:cruise) { customers(:cruise) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }

  before do
    login_user(nolan)
    give_authority(nolan, "删除客户")
  end

  describe "POST /api/v1/customers" do
    it "添加新客户" do
      params = {
        customer: {
          name: "克里斯蒂安",
          note: "我是克里斯蒂安贝尔",
          phone: "18668243444",
          phones: %w(18668244444 18668244442),
          gender: "male",
          id_number: "238423094823908230"
        }
      }

      VCR.use_cassette("letter_avatar") do
        auth_post :create, params
      end

      expect(nolan.company.customers.find_by(name: "克里斯蒂安")).to be_present
      expect(nolan.customers.find_by(name: "克里斯蒂安")).to be_present
      expect(nolan.customers.find_by(name: "克里斯蒂安").avatar).to be_present
    end

    it "保存节日提醒，并生成相应提醒" do
      ExpirationSetting.init(nolan.company)
      params = {
        customer: {
          name: "克里斯蒂安",
          note: "我是克里斯蒂安贝尔",
          phone: "18668243444",
          phones: %w(18668244444 18668244442),
          gender: "male",
          id_number: "238423094823908230",
          memory_dates: [
            { name: "生日", date: "12-14" },
            { name: "爱人生日", date: "3-6" },
            { name: "asdf", date: "4-7" }
          ]
        }
      }

      VCR.use_cassette("letter_avatar") do
        auth_post :create, params
      end

      customer = Customer.last
      expect(customer.memory_dates).to be_present

      notifications = ExpirationNotification.where(company_id: nolan.company_id)
      expect(notifications.count).to eq 3
      expect(notifications.first.associated).to eq customer
    end

    it "已存在的客户不能添加(更多联系方式)" do
      params = {
        customer: {
          name: "克里斯蒂安",
          note: "我是克里斯蒂安贝尔",
          phone: "18668243444",
          phones: ["18668244444", cruise.phones.first]
        }
      }

      VCR.use_cassette("letter_avatar") do
        auth_post :create, params
      end
      expect(response_json[:errors]).to be_present
    end

    it "已存在的客户不能添加(主要联系方式)" do
      params = {
        customer: {
          name: "克里斯蒂安",
          note: "我是克里斯蒂安贝尔",
          phone: cruise.phone,
          phones: ["18668244444"]
        }
      }

      VCR.use_cassette("letter_avatar") do
        auth_post :create, params
      end
      expect(response_json[:errors]).to be_present
    end
  end

  describe "POST /api/v1/customers/import" do
    it "批量导入客户" do
      customers = ParamsBuilder.build(
        "customers/import",
        test: "test"
      ).deep_symbolize_keys!.fetch(:import).fetch(:customers)

      expect do
        auth_post :import, customers: customers
      end.to change { Customer.count }.by(customers.size)
    end

    it "过滤号码重复的用户" do
      customers = ParamsBuilder.build(
        "customers/import_with_same_phones",
        test: "test"
      )
                               .deep_symbolize_keys!.fetch(:import).fetch(:customers)

      expect do
        auth_post :import, customers: customers
      end.to change { Customer.count }.by(customers.size - 3)

      expect(response_json[:data][:filtered_phones].size).to eq 2
    end
  end

  describe "GET /api/v1/customers/:id" do
    it "获取客户详情" do
      cruise.update!(
        memory_dates: [
          { name: "生日", date: "12-14" },
          { name: "爱人生日", date: "3-6" },
          { name: "asdf", date: "4-7" }
        ]
      )
      auth_get :show, id: cruise.id

      expect(response_json[:data][:id]).to eq cruise.id
    end
  end

  describe "PUT /api/v1/customers/:id" do
    it "更新客户详情" do
      bale_name = "bale"

      params = {
        name: bale_name,
        note: "我是克里斯蒂安贝尔",
        phones: %w(18668244444 18668244442),
        phone: "18668243444",
        avatar: "I'm a avatar"
      }
      auth_put :update, id: cruise.id, customer: params

      expect(response_json[:data][:name]).to eq bale_name
    end

    it "更新用户的节日信息" do
      ExpirationSetting.init(nolan.company)
      params = {
        memory_dates: [
          { name: "生日", date: "12-14" },
          { name: "爱人生日", date: "3-6" },
          { name: "asdf", date: "4-7" }
        ]
      }

      auth_put :update, id: cruise.id, customer: params
      keys = response_json[:data][:memory_dates].first.keys
      expect(keys).to include :name
    end
  end

  describe "DELETE /api/v1/customers/:id" do
    it "删除客户" do
      auth_delete :destroy, id: cruise.id

      expect { Customer.find(cruise.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "GET /api/v1/customers/" do
    it "获取所有客户列表" do
      auth_get :index

      expect(response_json[:data].size).to be > 0
    end
  end

  describe "GET /api/v1/customers/follow_up" do
    it "获取跟进客户列表" do
      auth_get :follow_up

      expect(response_json[:data].size).to eq 0
    end
  end

  describe "GET /api/v1/customers/:id/intentions" do
    it "获取客户的意向列表" do
      auth_get :intentions, id: cruise.id

      expect(response_json[:data].size).to be > 0
    end
  end

  shared_examples "keyword search" do
    describe "客户列表关键词搜索" do
      it "根据客户名称，号码，意向内容，成交车辆名称搜索" do
        auth_get :index, query: { keyword: keyword }

        expect(response_json[:data].size).to be > 0
      end
    end
  end

  describe "GET /api/v1/customers/" do
    it "搜索其他联系方式中的手机" do
      auth_get :index, query: { phones_include: "134" }

      expect(response_json[:data].size).to be > 0
    end

    it "搜索主要联系手机" do
      auth_get :index, query: { phones_include: "13744444446" }

      expect(response_json[:data].size).to be > 0
    end

    it "搜索手机号失败" do
      auth_get :index, query: { phones_include: "ert" }

      expect(response_json[:data].size).to eq 0
    end

    it "根据客户名称，号码搜索失败" do
      auth_get :index, query: { keyword: "ert" }

      expect(response_json[:data].size).to eq 0
    end

    it_behaves_like "keyword search" do
      let(:keyword) { cruise.name }
    end

    it_behaves_like "keyword search" do
      let(:keyword) { cruise.phone }
    end

    it_behaves_like "keyword search" do
      let(:keyword) { cruise.phones.first[0..3] }
    end
  end

  describe "GET memory_dates" do
    it "得到列表" do
      auth_get :memory_dates
      expect(response_json[:data]).to be_present
    end
  end
end
