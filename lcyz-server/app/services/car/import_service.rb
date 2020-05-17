class Car < ActiveRecord::Base
  class ImportService
    attr_reader :car

    HOST     = ENV.fetch("IMPORT_URL")
    VIP_HOST = ENV.fetch("IMPORT_VIP_URL")

    def initialize(user)
      @user = user
    end

    def execute(car_acquisition_params)
      car_params = car_acquisition_params.fetch(:car_params, {})
      acquisition_transfer_params = car_acquisition_params.fetch(:acquisition_transfer_params, {})

      Car.transaction do
        @car = Car.where(company_id: @user.company_id)
                  .find_by(imported: car_params[:imported])
        unless @car
          car = Car.new(car_params.merge!(shop_id: @user.shop_id,
                                          company_id: @user.company_id))

          @car = Car::CreateService.new(
            @user, car, acquisition_transfer_params
          ).execute.car
        end
      end

      self
    end

    # 得到这个link_id所对应的车辆链接
    def car_links(link_id)
      vip(link_id) # .concat(normal(link_id))
    end

    # 解析每辆车页面里的信息，把相应值进行匹配
    # @returns: { car_params: {}, acquisition_transfer_params: {} }
    # @params: link: 每辆车的详情页
    def data_parse(link)
      @doc = fetch(link)
      return {} if @doc.blank?

      transfer_params = acquisition_transfer_params.reject { |_, v| v.blank? }
      { car_params: car_params(link).merge(car_conf_data_params),
        acquisition_transfer_params: transfer_params
      }
    end

    def data_filter(car_params)
      car = car_params.fetch(:car_params, {})
      car.merge!(
        transmission:      convert_text(car, :transmission),
        emission_standard: convert_text(car, :emission_standard),
        car_type:          convert_text(car, :car_type)
      )

      images = []
      car[:images].each_with_index do |img, index|
        img = "http:" + img
        begin
          image = { url: AliyunOss.put(img) }
        rescue
          next
        end

        image[:is_cover] = true if index == 0

        images << image
      end

      car.except!(:images)
      car[:images_attributes] = images

      car_params[:car_params] = car

      {
        car_params: car_params.fetch(:car_params),
        acquisition_transfer_params: car_params.fetch(:acquisition_transfer_params)
      }
    end

    private

    def car_params(link)
      license_info, licensed_at = license_related_info
      online_price = online_price_wan

      {
        acquisition_type: "acquisition", # 默认收购
        acquisition_price_cents: 0,      # 收购价默认为0
        license_info: license_info,      # 默认已上牌
        acquirer_id:  @user.company.owner_id, # 收购员默认为公司老板
        acquired_at:  Time.zone.now.beginning_of_day, # 收购时间
        imported:     Digest::SHA1.hexdigest(link), # 导入标记
        series_name:  series_name,       # 车系
        style_name:   style_name,        # 车款
        brand_name:   brand_name,        # 品牌
        name:         name,              # 车辆名
        mileage:      mileage,           # 表显里程
        licensed_at:  licensed_at,       # 首次上牌
        online_price_wan: online_price, # 网络标价
        show_price_wan:   online_price, # 展厅标价
        emission_standard: emission_standard, # 排放标准
        star_rating: 5,                       # 车辆星级，默认为5星
        images:      car_images               # 车辆图片
      }
    end

    def acquisition_transfer_params
      return {} if basic_data.blank?
      {
        annual_inspection_end_at: transfer_annual_inspection_end_at,       # 年审到期日
        compulsory_insurance_end_at: transfer_compulsory_insurance_end_at, # 交强险到期日
        transfer_count: transfer_count                                     # 过户次数
      }
    end

    def car_conf_data_params
      return {} if conf_data.blank?
      {
        transmission:   transmission,   # 变速器
        car_type:       car_type,       # 车辆类型
        exterior_color: exterior_color, # 外饰颜色
        displacement:   displacement,   # 排气量
        is_turbo_charger: turbo_charger?
      }
    end

    def fetch(url)
      args = <<-ARGS.squish!
        -H 'Accept-Encoding: gzip, deflate, sdch'
        -H 'Accept-Language: zh-CN,zh;q=0.8,en;q=0.6' -H 'Upgrade-Insecure-Requests: 1'
        -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.79 Safari/537.36'
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0'
        -H 'Connection: keep-alive'
        --connect-timeout 10 -m 20 --compressed
      ARGS

      mock_ip = "http://116.62.100.92:3128"
      response = `curl -x #{mock_ip} #{url} #{args}`

      response = `curl #{url} #{args}` if Rails.env.test?

      response.encode!(
        "UTF-8", "GB2312",
        undef: :replace, replace: "?", invalid: :replace)
      Nokogiri::HTML.parse response
    rescue
      nil
    end

    def car_name
      @doc.css(".car-title > h2").text.try(:split, " ", 2)
    end

    def series_name
      car_name.try(:first)
    end

    def style_name
      return if car_name.blank?
      car_name.second.try(:gsub, /\s+/, " ")
    end

    def brand_name
      Megatron.brand(series_name)["data"]["name"]
    rescue
      ""
    end

    def name
      "#{brand_name} #{series_name} #{style_name}"
    end

    def details
      @details = @doc.css(".details > ul > li > span")
    end

    def mileage
      detail_0 = details[0]
      return if detail_0.blank?
      text = detail_0.text
      return if text.blank?
      text.strip[0..-4].to_f
    end

    def licensed_at
      date_string = details[1].try(:text)
      return unless date_string =~ /\d/
      Date.parse(date_string.gsub(/年|月/, "-") + "-1")
    end

    def license_related_info
      licensed_date = licensed_at
      [licensed_date.nil? ? "unlicensed" : "licensed", licensed_date]
    end

    def online_price_wan
      @doc.css("#car_price").attr("value").value
    end

    # basic_data for the car
    def basic_data
      @doc.css("#anchor01 > ul > li")
    end

    def annual_inspection_end_at
      basic_data.detect { |d| d.css("span").text.include?("年检到期") }
    end

    def transfer_annual_inspection_end_at
      return if annual_inspection_end_at.blank?
      Date.parse(annual_inspection_end_at.text.split("月", 2).first.gsub(/年|月/, "-") + "-01")
    end

    def transfer_compulsory_insurance_end_at
      compulsory_insurance_end_at = basic_data.detect { |d| d.css("span").text.include?("交强险到期") }
      return if compulsory_insurance_end_at.blank?
      Date.parse(compulsory_insurance_end_at.text.split("月", 2).first.gsub(/年|月/, "-") + "-01")
    end

    def transfer_count
      count = basic_data.detect { |d| d.css("span").text.include?("过户次数") }
      return if count.blank?
      count.text.match(/(.*)次/).try(:captures).try(:first)
    end

    def emission_standard
      page_text = basic_data.detect { |d| d.css("span").text.include?("排放标准：") }.text
      attr_value_text(page_text)
    end

    def conf_data
      @doc.css("#anchor02 > ul > li")
    end

    def conf_data_text(reg_text)
      conf_data.detect { |d| d.css("span").text.include?(reg_text) }.text
    end

    # 把类似"变速器"这样的文字串进行一个简单处理，方便提取内容
    def attr_value_text(value)
      return "" if value.blank?
      value_text = value.split(/.*：/)[-1]
      return "" if value_text.blank?
      value_text.strip
    end

    def transmission
      attr_value_text(conf_data_text("变 速 器"))
    end

    def car_type
      attr_value_text(conf_data_text("车辆级别"))
    end

    def exterior_color
      attr_value_text(conf_data_text("颜　　色"))
    end

    def displacement_base
      attr_value_text(conf_data_text("发 动 机")).split(" ").first
    end

    def displacement
      displacement_base[0...-1]
    end

    def turbo_charger?
      displacement_base[-1] != "L"
    end

    def car_images
      @doc.css(".focusimg-pic > ul > li").inject([]) do |images, li|
        images << li.css("a img").attr("src").to_s
      end
    end

    # 分别得到这个link_id对应的vip及normal里的car_links
    def vip(link_id)
      car_links_with_type(:vip, link_id)
    end

    def normal(link_id)
      car_links_with_type(:normal, link_id)
    end

    def car_links_with_type(type, link_id)
      fetch_url = {
        vip:    "http://dealers.che168.com/shop/#{link_id}/list/"
        # normal: "http://www.che168.com/dealer/carlist/#{link_id}.html"
        # che168升级，本链接会重定向到上一个地址, 取消从本地址抓取数据
      }.fetch(type) { "" }

      car_links = []

      begin
        doc = fetch(fetch_url)
        return [] unless doc

        loop do
          car_links.concat(send("#{type}_find_links", doc))

          next_page, doc = send "#{type}_next_page", doc
          break unless next_page && doc
        end
      rescue
        doc = nil
      end

      car_links
    end

    def vip_find_links(doc)
      doc.css(".piclist > ul > li > .title > a").inject([]) do |car_links, e|
        link = e.attr("href")
        link = link.match("//(.+)").captures.first if link.start_with?("//")
        car_links << link
      end
    end

    def normal_find_links(doc)
      doc.css(".newcar > ul li").inject([]) do |car_links, e|
        car_links << "#{HOST}#{e.css("a").attr("href")}"
      end
    end

    def vip_next_page(doc)
      next_page = doc.at_css(".page-item-next")
      if next_page
        doc = fetch(VIP_HOST + doc.css(".page-item-next").attr("href"))
      end

      [next_page, doc]
    end

    def normal_next_page(doc)
      next_page = doc.at_css(".list_page > a:contains('下一页')")
      if next_page
        doc = fetch(HOST + doc.css(".list_page > a:contains('下一页')").attr("href"))
      end
      [next_page, doc]
    end

    def convert_text(car_params, key)
      value = car_params.fetch(key, "")
      double_value_check = value.index("(")
      multi_value_check = value.index("+")
      if double_value_check.present?
        value = value[double_value_check + 1..-2]
      elsif multi_value_check.present?
        value = value[0..multi_value_check - 1]
      end

      k_v = I18n.t("import.#{key}")
      result = k_v.select { |k, _| value == k.to_s }

      result.present? ? I18n.t("import.#{key}.#{result.keys.first}") : nil
    end
  end # end of ImportService class
end
