class Company < ActiveRecord::Base
  class OfficialWebsiteUrlService
    def execute
      data = youhaosuda_data.fetch("info")
      if data.present?
        data.each do |item|
          cid = item.fetch("cid")
          company = Company.find(cid)
          company.update_columns(official_website_url: item.fetch("url")) if company.present?
        end
      end
    end

    def youhaosuda_data
      JSON.parse(Util::Request.get("http://chelaike.ibanquan.com/api/queryAll"))
    end
  end
end
