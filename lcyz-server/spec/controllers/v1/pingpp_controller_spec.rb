require "rails_helper"

RSpec.describe V1::PingppController do
  fixtures :companies, :users, :orders, :token_packages

  let(:token_package) { token_packages(:token_packages_a) }

  describe "notify" do
    context "401" do
      it "returns 401" do
        post :notify

        expect(response.status).to eq 401
      end
    end

    context "403" do
      it "returns 403" do
        request.headers[:HTTP_X_PINGPLUSPLUS_SIGNATURE] = "something"
        post :notify

        expect(response.status).to eq 403
      end
    end

    context "400" do
      before do
        request.headers[:HTTP_X_PINGPLUSPLUS_SIGNATURE] = "something"
        allow_any_instance_of(OpenSSL::PKey::RSA).to receive(:verify).and_return(true)
      end

      it "returns missing type" do
        post :notify

        expect(response.status).to eq 400
        expect(response.body).to eq "Event 对象中缺少 type 字段"
      end

      it "returns unknown type" do
        post :notify, type: "unknown"

        expect(response.status).to eq 400
        expect(response.body).to eq "未知 Event 类型"
      end
    end

    let(:params) do
      {
        "id" => "evt_ugB6x3K43D16wXCcqbplWAJo",
        "created" => 1440407501,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => { "id" => "ch_Xsr7u35O3m1Gw4ed2ODmi4Lw",
                        "object" => "charge",
                        "created" => 1440407501,
                        "livemode" => true,
                        "paid" => true,
                        "refunded" => false,
                        "app" => "app_urj1WLzvzfTK0OuL",
                        "channel" => "upacp",
                        "order_no" => "123456789",
                        "client_ip" => "127.0.0.1",
                        "amount" => 100,
                        "amount_settle" => 0,
                        "currency" => "cny",
                        "subject" => "Your Subject",
                        "body" => "Your Body",
                        "extra" => {},
                        "time_paid" => 1440407501,
                        "time_expire" => 1440407501,
                        "time_settle" => nil,
                        "transaction_no" => "1224524301201505066067849274",
                        "refunds" => {
                          "object" => "list",
                          "url" => "/v1/charges/ch_Xsr7u35O3m1Gw4ed2ODmi4Lw/refunds",
                          "has_more" => false,
                          "data" => nil },
                        "amount_refunded" => 0,
                        "failure_code" => nil,
                        "failure_msg" => nil,
                        "metadata" => {},
                        "credential" => {},
                        "description" => nil }
        },
        "object" => "event",
        "pending_webhooks" => 0,
        "request" => "iar_qH4y1KbTy5eLGm1uHSTS00s"
      }
    end

    context "200" do
      before do
        request.headers[:HTTP_X_PINGPLUSPLUS_SIGNATURE] = "something"
        allow_any_instance_of(OpenSSL::PKey::RSA).to receive(:verify).and_return(true)
      end

      before do
        order = Order.find_by_id(123456789)
        order.action = :token
        order.amount_cents = 10010
        order.token_type = :company
        order.save
      end

      it "returns 200" do
        post :notify, params

        expect(response.status).to eq 200
        expect(response.body).to eq "OK"
      end

      it "update order status" do
        expect do
          post :notify, params
        end.to change { Order.find_by_id(123456789).status }
          .from("charge")
          .to("success")
      end

      let(:bloc) do
        proc do
          Token.where(company_id: @order.company_id).first.try(:balance).to_f
        end
      end

      context "token_package" do
        before do
          @order = Order.find_by_id(123456789)
          @order.action = :token_package
          @order.orderable = token_package
          @order.save
        end

        it "adds tokens" do
          expect do
            post :notify, params
          end.to change { bloc.call }
            .from(0)
            .to(token_package.total_balance)
        end
      end

      context "token" do
        before do
          @order = Order.find_by_id(123456789)
          @order.action = :token
          @order.amount_cents = 10010
          @order.save
        end

        it "adds tokens" do
          expect do
            post :notify, params
          end.to change { bloc.call }
            .from(0)
            .to(@order.amount_yuan)
        end
      end
    end
  end
end
