require "rails_helper"

RSpec.describe V1::PasswordsController do
  fixtures :all

  let(:nolan) { users(:nolan) }
  let(:changed_password) { "IchangeThePassword" }
  let(:reset_token) { "abcd" }

  describe "PUT /api/v1/password" do
    context "changes password by original_password" do
      it "用户修改密码" do
        login_user(nolan)

        auth_put :update, user: {
          original_password: "ThePrestige",
          password: "Interstellar"
        }

        expect(nolan.reload.authenticate("Interstellar")).not_to be_falsey
      end
    end

    context "changes password by cms" do
      before do
        allow(SMS).to receive(:generate_token).and_return(reset_token)
        cms = "验证码: #{reset_token}（该验证码用于忘记密码后的密码变更），工作人员不会向您索要，请勿向任何人泄露。（十分钟内有效）"
        allow(Yunpian).to receive(:send_to!).with(nolan.phone, cms)
      end

      it "gets a pass_reset_token through GET /api/v1/password/edit" do
        get :edit, user: { phone: nolan.phone }

        expect(nolan.reload.pass_reset_token).to eq reset_token

        get :edit, user: { phone: nolan.phone }
        expect(response.status).to eq 403

        travel_to Time.zone.now + 5.minutes
        get :edit, user: { phone: nolan.phone }
        expect(nolan.reload.pass_reset_token).to eq reset_token
      end

      it "can update password through reset_token" do
        get :edit, user: { phone: nolan.phone }

        put :update, user: {
          phone: nolan.phone,
          pass_reset_token: reset_token,
          password: changed_password
        }

        expect(nolan.reload.authenticate(changed_password)).to be_truthy
      end

      it "will be expired after 10 minutes" do
        key = nolan.send(:reset_password_limit_key)
        get :edit, user: { phone: nolan.phone }

        expect(RedisClient.current.ttl(key)).to eq 10.minutes.to_i
      end

      it "raise 401 after expired" do
        get :edit, user: { phone: nolan.phone }
        RedisClient.current.del(nolan.send(:reset_password_limit_key))

        put :update, user: {
          phone: nolan.phone,
          pass_reset_token: reset_token,
          password: changed_password
        }

        expect(response.status).to eq 401
      end

      it "can try 10 times" do
        nolan.update_columns(
          pass_reset_token: reset_token,
          pass_reset_expired_at: Time.zone.now + 1.hour
        )

        10.times do
          put :update, user: {
            phone: nolan.phone,
            pass_reset_token: "1234",
            password: changed_password
          }
        end

        put :update, user: {
          phone: nolan.phone,
          pass_reset_token: reset_token,
          password: changed_password
        }

        expect(nolan.reload.authenticate(changed_password)).to be_falsey
      end
    end
  end
end
