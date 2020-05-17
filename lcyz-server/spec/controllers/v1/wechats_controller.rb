require "rails_helper"

RSpec.describe V1::WechatsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:chelaike_mp) { wechat_apps(:chelaike_mp) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/wechats/authorization" do
    it "获取公众号授权回调url" do
      VCR.use_cassette("wechats_authorization") do
        auth_get :authorization
      end
      expect(response_json[:data][:wechat_app]).to be_present
    end
  end

  describe "GET /api/v1/wechats/authorized_callback" do
    it "授权登录回调" do
      VCR.use_cassette("wechats_authorized_callback") do
        auth_get :authorized_callback, company_id: zhangsan.company_id
      end

      expect(response.body).to eq "授权成功。车来客已接管应用，感谢您对车来客的支持。"
    end
  end

  describe "POST /api/v1/wechats/authorize_callback" do
    it "接受微信推送的component_verify_ticket" do
      xml_data = <<-XML.strip_heredoc
        <xml>
          <AppId><![CDATA[wxefe9e45b217bc492]]></AppId>
          <Encrypt>
            <![CDATA[yuFfaCXVX81law9gR0+q6kVaNoAsrnBS+/eqmK/wI6kCcMuNbKHa2eOw+
            suIByowLLB0jXUgBc4BzpkeEn2PYPup+ksB/w2X/8Eiq/Xdr+lR6CKtX2sT0413EEf
            qL0817mp1gP05YXXdKIQNFNDDt6xK8NgqB/eNuCDwtjHUsTWWmZdWBIVNaXFUnbgNF
            gNqgD28q6zsMDhMvIwZglOGE5nqcL7VZwbkDm6NmTvRho0/mKEIk//iGSJgZT82gdp
            fgbcvdFshgv6Kj2bwEQ6l56zySpkXYuH07g/PWSVwURFy6c6piFYzAJMgcYIRG73k6
            JTPhXq+WzXTdLfgeH4rBAFDysk8peV6UGN8yybCq9d046ziyrMhfvqoKl+g94FN5Hh
            ntt7gPHnuHFNU5IaDRAZfQ1rXv9Ep1qaKIrceDNbgSKP420uPeQDBloVrXKC4BeL2s
            HAF1tNs7VD3yw1w4w==]]>
          </Encrypt>
        </xml>
      XML

      post :authorize_callback, xml_data,
           signature: "3f11d2c3228b365849fdec3663a0d2de27a23ee2",
           timestamp: "1449553252",
           nonce: "70172940",
           encrypt_type: "aes",
           msg_signature: "b2b1f4b01497c8535cb637d48fd26ebb23b65339"

      expect(response.body).to eq "success"
    end
  end

  describe "POST /api/v1/wechats/:app_id/events_callback" do
    it "接受事件推送" do
      xml_data = <<-XML.strip_heredoc
        <xml>
          <ToUserName><![CDATA[gh_ef19d7012987]]></ToUserName>
          <Encrypt>
            <![CDATA[AgzZKiU61swvQjHlheeJ6vpG3fn3nZYhstr+H7kwI0aRs5hPS5lf/8JXq
            na5yR27OghSeZ9/ToCCEiAR7SZfkm4IUE1movpd4UW431fTQDBBOIocaR5vp4ixgrY
            d+T5q4gfODYq0YewEK2k3TBX+3hGIKClPDUjJPbhsd+6z19Oqr+i+8j/zQJ1+2HL4q
            lJnceqjF3iXdRDMK7NScWEr4wjdXaknF85URA4N26VObNPvOyfedJEkIbVpVFykke7
            vQkmhrI6PLYBzA+Fyi3gm8wzX9pXyoiWabjL5wo9g8yQPQRidIhw3QMWMtYLjZBQ2b
            YLw93q8MWt1gTZTVfIP4TmX2KK+TI5KbnwOe2rzTVU1eU1VtnFEvjUJPrM7sGNYEml
            3OrGrJtkmjvlcE4zssXMp5DrTswsbEtTNTr7NVW+knwaK4PlYvQtBSLfWWdP2VfskU
            bThitdgaaxxHXCWeIm2dRzmTXb9Fi13CgvTQ07X421dUnS9TA2rXRzP9ecDqQkavfs
            tcQatQVwyfmXkMY0++W17XpdVPa8LqM8tuOixGwKGrpaVlgdGPvGo0SYgFuZSfjW7g
            l8KpNcALsj+c1KBxer90+wnDR0FEPJqBsSulIqbCRd6Rldk7H22n/CD]]>
          </Encrypt>
        </xml>
      XML

      allow(Wechat::Reducer).to receive(:execute).and_return(nil)

      post :events_callback, xml_data,
           id: chelaike_mp.app_id,
           signature: "7f0aa17bf63d482ba7e9e6dd3428cab664de7df4",
           timestamp: "1449555650",
           nonce: "977880656",
           encrypt_type: "aes",
           msg_signature: "c3e8b0ab8d4b9e2edc67c8f5668d4c8aafd84815"

      expect(response.body).to eq "success"
    end
  end
end
