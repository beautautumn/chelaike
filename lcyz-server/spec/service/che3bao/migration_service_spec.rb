require "rails_helper"

if ENV["IMPORT"]
  RSpec.describe Che3bao::MigrationService do
    let(:che3bao_corp_id) { 45 }
    let(:che3bao_corp) { Che3bao::Corp.find(che3bao_corp_id) }

    describe "import users" do
      before do
        migration_service = Che3bao::MigrationService.new(che3bao_corp_id)

        migration_service.send(:import_company)
        migration_service.send(:import_users)

        @company = Company.last
      end

      it "has company" do
        expect(@company).to be_present
      end

      it "company has an owner" do
        expect(@company.owner).to be_present
      end

      it "imports all users data" do
        users_scope = @company.users
        staffs_scope = che3bao_corp.staffs

        expect(
          users_scope.where("manager_id is not null").count
        ).to eq staffs_scope.where("parent_id is not null").count

        expect(users_scope.count).to eq staffs_scope.count
      end
    end

    describe "import cars" do
      it "imports all cars" do
        Che3bao::MigrationService.new(che3bao_corp_id).execute

        @company = Company.last
        expect(@company.cars.count).to eq che3bao_corp.stocks.count
      end
    end
  end
end
