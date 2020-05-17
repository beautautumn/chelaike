# frozen_string_literal: true
module CompanyHelper
  def mock_company(attrs = {})
    attrs = {
      id: 4,
      name: "杭州天车",
      contact: "天车111",
      contact_mobile: "2342535345",
      acquisition_mobile: "13123",
      sale_mobile: "3675467567567",
      logo: "http://oss-playground.che3bao.com/images/a5ffe52d-8997-4167-a611-ede69becbab7.jpg",
      note: "啦啦啦啦德玛西亚的撒打算的1",
      province: "浙江省",
      city: "杭州市",
      district: nil,
      street: "拱墅区华源创意工场56565",
      owner_id: 79,
      created_at: "2015-12-04T11:45:10.168+08:00",
      stock_number_by_vin: false,
      automated_stock_number_start: 0,
      automated_stock_number_prefix: "HZTC",
      in_alliances: true,
      cars_count: 400,
      qrcode: "http://images/9a8adbe0-aa11-498f-9f2a-c9184c6d7d49.png",
      banners: [],
      shops_count: 4,
      nickname: "",
      slogan: nil
    }.merge(attrs)

    company_struct = OpenStruct.new(attrs)
    allow(Chelaike::CompanyService).to receive(:fetch_company_info).and_return(company_struct)
  end
end
