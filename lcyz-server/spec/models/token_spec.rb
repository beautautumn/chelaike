# == Schema Information
#
# Table name: tokens # 车币
#
#  id         :integer          not null, primary key # 车币
#  company_id :integer
#  balance    :decimal(12, 2)   default(0.0)
#  user_id    :integer                                # 用户个人的车币
#  token_type :string           default("company")    # 标记个人或公司的车币
#

require "rails_helper"

RSpec.describe Token, type: :model do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }

  describe "#increment_balance!" do
    it "如果类型是user，给user增加balance" do
      token = Token.create!(user_id: 1, token_type: :user, balance: 10)
      token.increment_balance!(:user, 12.3)
      token.reload
      expect(token.balance).to eq 22.3
      expect(token.company).to be_nil
    end

    it "如果类型是company,给company增加balance" do
      token = Token.create!(company_id: 1, token_type: :company, balance: 10)
      token.increment_balance!(:company, 12.3)
      token.reload
      expect(token.balance).to eq 22.3
      expect(token.user).to be_nil
    end

    it "如果type不一样，抛出异常" do
      token = Token.create!(company_id: 1, token_type: :company, balance: 10)
      expect do
        token.increment_balance!(:user, 12.3)
      end.to raise_error(Token::TypeError)
    end
  end

  describe ".get_token" do
    it "如果参数是公司类型，得到公司的token" do
      company_token.update(company_id: tianche.id)
      expect(Token.get_token(tianche)).to eq company_token
    end

    it "如果参数是User类型，得到个人的token" do
      user_token.update(user_id: zhangsan.id)
      expect(Token.get_token(zhangsan)).to eq user_token
    end
  end

  describe ".get_or_create_token!" do
    it "如果参数是公司类型，得到公司的token" do
      company_token.update(company_id: tianche.id)
      expect(Token.get_or_create_token!(tianche)).to eq company_token

      Token.destroy_all
      token = Token.get_or_create_token!(tianche)
      expect(token).to be_persisted
      expect(token.company_id).to eq tianche.id
      expect(token.token_type).to eq "company"
    end

    it "如果参数是User类型，得到个人的token" do
      user_token.update(user_id: zhangsan.id)
      expect(Token.get_or_create_token!(zhangsan)).to eq user_token

      Token.destroy_all
      token = Token.get_or_create_token!(zhangsan)
      expect(token).to be_persisted
      expect(token.user_id).to eq zhangsan.id
      expect(token.token_type).to eq "user"
    end
  end

  describe "#owner_id" do
    it "根据类型返回拥有者ID" do
      expect(company_token.owner_id).to eq company_token.company_id
      expect(user_token.owner_id).to eq user_token.user_id
    end
  end
end
