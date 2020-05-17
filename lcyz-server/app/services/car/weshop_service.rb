class Car < ActiveRecord::Base
  class WeshopService
    attr_accessor :car

    def initialize(car = nil)
      @car = car.presence
    end

    # 由用户分享出去的车辆详情页地址
    def shared_detail_url(user_id)
      car_url = new_official_shared_detail_url(user_id)
      "http://#{car_url}?seller_id=#{user_id}&shared_from=true"
    end

    def car_detail_url
      "http://#{new_official_shared_detail_url}"
    end

    # 构造新官网车辆列表地址
    def cars_list_url(user, query_params)
      q_params = MultiJson.load(query_params)
      querys = { query: q_params }.to_query

      domain = if env_production?
                 official_company_domain(user.company_id)
               else
                 "tianche.site.chelaike.com"
               end

      "http://#{domain}/cars/shared_index?seller_id=#{user.id}&#{querys}"
    end

    # 开通官网
    def setup_tenant_in_weshop(company)
      return nil unless env_production?

      domain = ENV["WESHOP_DOMAIN"]
      RestClient::Request.execute(
        method: :post,
        url: "http://#{domain}/api/create_tenant",
        payload: {
          api: {
            name: company.name,
            company_id: company.id,
            company_type: "solo",
            phone: company.try(:owner).try(:phone)
          }
        },
        timeout: 5
      )
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.info e
      return nil
    end

    private

    def env_production?
      Rails.env.production? || Rails.env.bm_production?
    end

    def new_official_shared_detail_url(user_id = nil)
      unless env_production?
        return "tianche.lina-site.chelaike.com/cars/#{@car.id}"
      end

      obj = User.where(id: user_id).first || @car
      company_id = obj.company_id

      domain = official_company_domain(company_id)
      "#{domain}/cars/#{@car.id}"
    end

    def official_company_domain(company_id)
      url = "http://#{ENV['WESHOP_DOMAIN']}/api/company_url/#{company_id}"

      result = MultiJson.load(Util::Request.get(url), symbolize_keys: true)

      data = result[:data]
      tld = data.fetch(:tld)
      subdomain = data.fetch(:subdomain)

      if tld.present?
        tld
      else
        "#{subdomain}.#{ENV['WESHOP_DOMAIN']}"
      end
    end

    def youhaosuda_company_domain(user = nil)
      company_id = user.try(:company_id) || @car.company_id
      url = "http://chelaike.ibanquan.com/api/queryURL?cid=#{company_id}"
      result = JSON.parse(Util::Request.get(url))
      status = result.fetch("status").to_i

      self_domained = status == 1
      domain_url = result.fetch("url")
      [self_domained, domain_url]
    end

    def construct_free_url(domain, user_id = nil)
      index = domain.index(/#!/)
      domain_copy = domain.clone

      with_user_id = if user_id.present?
                       domain_copy.insert(index, "?seller_id=#{user_id}/")
                     else
                       domain_copy.insert(index, "")
                     end

      "#{with_user_id}product/#{@car.id}"
    end
  end
end
