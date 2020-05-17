require "rails_helper"

RSpec.describe Intention::CheckService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:doraemon) { customers(:doraemon) }
  let(:cruise) { customers(:cruise) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:gian_seeking_aodi) { intentions(:gian_seeking_aodi) }
  let(:cruise_sell_aodi) { intentions(:cruise_sell_aodi) }
  let(:shizuka_seeking_aodi) { intentions(:shizuka_seeking_aodi) }

  describe "private #generate_error_message(intention)" do
    context "agency is false" do
      context "assignee of the intention is the current_user" do
        it "returns error_message as '您已有该客户正在跟进的意向'" do
          message = Intention::CheckService.new(zhangsan).send(
            :generate_error_message, doraemon_seeking_aodi, "123"
          )

          expect(message).to eq Intention::CheckService::ErrorMessage.processing
        end
      end

      context "assignee of the intention is not the current_user" do
        it "returns error_message as '您已有该客户正在跟进的意向'" do
          message = Intention::CheckService.new(zhangsan).send(
            :generate_error_message, gian_seeking_aodi, "123"
          )

          expect(message).to eq Intention::CheckService::ErrorMessage.duplicated(gian_seeking_aodi)
        end
      end
    end

    context "agency is true" do
      context "own the customer" do
        it "returns error_message as long" do
          message = Intention::CheckService.new(zhangsan, agency: true).send(
            :generate_error_message, gian_seeking_aodi, doraemon.phones.first
          )

          expect(message).to eq Intention::CheckService::ErrorMessage.occupied(gian_seeking_aodi)
        end
      end

      context "does not own the customer" do
        it "returns error_message as '您的客户通讯录中没有该客户'" do
          message = Intention::CheckService.new(zhangsan, agency: true).send(
            :generate_error_message, cruise_sell_aodi, cruise.phones.first
          )

          expect(message).to eq Intention::CheckService::ErrorMessage.no_customers
        end
      end
    end
  end

  describe "#check!" do
    it "return nil if it's valid" do
      intention_params = {
        customer_phones: "123456", intention_type: "seek"
      }

      result = Intention::CheckService.new(zhangsan).check!(intention_params)
      expect(result).to be_nil
    end

    it "returns valid if existing finished intention" do
      conditions = { state: :invalid, intention_type: :seek, assignee_id: zhangsan.id }
      intention = Intention.where(conditions).first

      expect(intention).not_to be_blank
      intention_params = {
        customer_phones: intention.customer_phones, intention_type: "seek"
      }

      result = Intention::CheckService.new(zhangsan).check!(intention_params)
      expect(result).to be_nil
    end

    it "raises InvalidError if it's invalid" do
      intention_params = {
        customer_phones: shizuka_seeking_aodi.customer_phone,
        intention_type: "seek"
      }

      expect do
        Intention::CheckService.new(zhangsan).check!(intention_params)
      end.to raise_error(Intention::CheckService::InvalidError)
    end
  end
end
