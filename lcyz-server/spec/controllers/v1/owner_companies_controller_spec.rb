require "rails_helper"

RSpec.describe V1::OwnerCompaniesController do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche_peter) { owner_companies(:tianche_peter) }
  let(:tianche_allen) { owner_companies(:tianche_allen) }
  let(:pixar) { shops(:pixar) }
  let(:aodi) { cars(:aodi) }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET index" do
    context "没有query参数" do
      it "列出所有的归属车商" do
        OwnerCompany.update_all(shop_id: zhangsan.shop_id)
        auth_get :index
        expect(response_json[:data].count).to eq 2
      end
    end

    context "有query参数" do
      it "支持根据名字模糊查询" do
        OwnerCompany.update_all(shop_id: zhangsan.shop_id)
        auth_get :index, query: { name_cont: "归属" }
        expect(response_json[:data].count).to eq 2
      end
    end
  end

  describe "GET show" do
  end

  describe "POST create" do
    it "创建一个新的归属车商" do
      expect do
        auth_post :create, owner_company: {
                    name: "new company", shop_id: pixar.id
                  }
      end.to change { OwnerCompany.count }.by 1

      owner_company = OwnerCompany.last

      expect(owner_company.company).to eq zhangsan.company
    end

    it "归属于一家分店" do
      auth_post :create,
                owner_company: {
                  name: "new company",
                  shop_id: pixar.id
                }
      company = OwnerCompany.last
      expect(company.shop).to eq pixar
    end
  end

  describe "PUT update" do
    it "更新这个车商的信息" do
      auth_put :update,
               id: tianche_peter.id,
               owner_company: { name: "peter again" }
      expect(tianche_peter.reload.name).to eq "peter again"
    end
  end

  describe "DELETE destroy" do
    it "去掉car的归属车商" do
      aodi.update!(owner_company_id: tianche_peter.id)
      expect do
        auth_delete :destroy, id: tianche_peter.id
      end.to change { OwnerCompany.count }.by(-1)

      expect(aodi.reload.owner_company_id).to be_nil
    end
  end

  describe "GET query" do
    it "根据条件查询归属车商" do
      [tianche_peter].map do |c|
        c.update!(
          shop_id: pixar.id,
          company_id: zhangsan.company_id
        )
      end
      auth_get :query, query: { shop_id_eq: pixar.id }
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET query_shop" do
    it "根据条件查询归属车商" do
      [tianche_peter].map do |c|
        c.update!(
          shop_id: pixar.id,
          company_id: zhangsan.company_id
        )
      end
      auth_get :query_shop, shop_id: pixar.id
      # auth_get :query, shop_id: nil
      expect(response_json[:data]).to be_present
    end
  end
end
