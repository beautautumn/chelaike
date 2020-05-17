require "rails_helper"

RSpec.describe Rack::UTF8Validator do
  include RackHelper

  fixtures :all
  let(:tianche) { companies(:tianche) }

  it "查询字段编码错误处理" do
    search_params = {
      seriesName: "?????\xA1\xE4",
      accessToken: tianche.md5_name
    }

    get "/api/stock/list", search_params

    expect(last_response.body).to eq "{\"message\":\"编码错误\"}"
  end

  it "无法获取某品牌的车系, 如果参数编码有毒open" do
    get "/api/open/v1/series", brand: { name: "?????\xA1\xE4" }

    expect(last_response.body).to eq "{\"message\":\"编码错误\"}"
  end

  it "无法获取某品牌的车系, 如果参数编码有毒" do
    get "/api/v1/series", brand: { name: "?????\xA1\xE4" }

    expect(last_response.body).to eq "{\"message\":\"编码错误\"}"
  end
end
