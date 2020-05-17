class CheJianDing
  class BuyError < StandardError; end
  class << self
    def process(vin: "", license_plate: "", engine: "", mobile: "", order_no: "", is_image: false)
      # note: 这里的 vin 也有可能是图片地址
      order_hash = if is_image
                     image_buy(vin: vin,
                               mobile: mobile,
                               order_no: order_no)
                   else
                     buy(vin: vin,
                         license_plate: license_plate,
                         engine: engine,
                         mobile: mobile,
                         order_no: order_no)
                   end

      order = order_hash.fetch(:order)
      request_time = order_hash.fetch(:request_time)

      order_id = order["info"]["orderId"]
      # order_id = "2168a29025a84d949c38b4c7e8b6232f" if Rails.env != "production"
      # vin = "LHGRB186072026733" if Rails.env != "production"
      status = order["info"]["status"].to_i
      if status == 1
        hub_params = {
          order_id: order_id,
          order_status: status,
          order_message: order["info"]["message"],
          request_sent_at: request_time
        }

        hub_params = hub_params.merge(vin: vin) unless is_image

        return MaintenanceRecordHub.create!(hub_params)
      end
      raise BuyError, { status: order["info"]["status"], message: order["info"]["message"] }.to_json
    end

    def uid
      ENV.fetch("CHEJIANDING_UID")
    end

    def pwd
      ENV.fetch("CHEJIANDING_PWD")
    end

    def host
      ENV.fetch("CHEJIANDING_URL")
    end

    def id_param
      "b0a6467dbc5d9bff76e1404852ae185d"
    end

    def p
      "cjd"
    end

    def rsa_private_key
      @rsa_private_key ||=
        OpenSSL::PKey::RSA.new(File.read("config/chejianding/rsa_private_key.pem"))
    end

    def rsa_public_key
      @rsa_public_key ||=
        OpenSSL::PKey::RSA.new(File.read("config/chejianding/rsa_public_key.pem"))
    end

    def notify_public_key
      @notify_public_key ||=
        OpenSSL::PKey::RSA.new(File.read("config/chejianding/public_key.pem"))
    end

    def ping
      RestClient.get host
    end

    def account_info
      time = Util::Formatter.to_string_time(Time.zone.now)
      sign(uid + time + pwd)
      r = RestClient.post host + "/rest/publicif/accountInfo",
                          { uid: uid, time: time, sign: @signature },
                          "Content-Type" => "application/x-www-form-urlencoded"
      JSON.parse r
    end

    # 用户未授权=”-1”,
    # 其他错误=”0”，
    # 购买成功=”1”,
    # 签名错误=”2”，
    # 账户报告份额不足=”3”，
    # 不支持此品牌=”4”，
    # 厂商数据维护中=”5”，
    # vin前三位不可识别=”6”，
    # vin错误=”7”,
    # 该品牌需要输入车牌号,请输入正确格式的车牌号=“8” ，
    # 该品牌需要输入发动机号,请输入正确格式的发动机号=“9”
    # 该品牌需要输入发动机号和车牌号,请输入正确格式的发动机号和车牌号 = “10”
    def buy(vin: "", license_plate: "", engine: "", mobile: "", order_no: "")
      request_time = Time.zone.now
      time = Util::Formatter.to_string_time(request_time)
      sign(uid + vin.to_s + time + pwd)
      r = RestClient.post host + "/publicif/2.0/buy",
                          {
                            uid: uid,
                            time: time,
                            sign: @signature,
                            vin: vin,
                            licensePlate: license_plate,
                            engine: engine,
                            mobile: mobile,
                            orderNo: order_no
                          },
                          "Content-Type" => "application/x-www-form-urlencoded"

      { order: JSON.parse(r), request_time: request_time }
    end

    def image_buy(vin: "", mobile: "", order_no: "")
      # note: 这里的 vin 就是image_url
      request_time = Time.zone.now
      time = Util::Formatter.to_string_time(request_time)
      sign(uid + vin.to_s + time + pwd)
      r = RestClient.post host + "/publicif/2.0/buyByVinImg",
                          {
                            uid: uid,
                            time: time,
                            sign: @signature,
                            img_url: vin,
                            mobile: mobile,
                            orderNo: order_no
                          },
                          "Content-Type" => "application/x-www-form-urlencoded"
      { order: JSON.parse(r), request_time: request_time }
    end

    def order_info(order_id)
      time = Util::Formatter.to_string_time(Time.zone.now)
      sign(uid + order_id.to_s + time + pwd)
      r = RestClient.post host + "/rest/publicif/orderInfo",
                          {
                            uid: uid,
                            orderId: order_id,
                            time: time,
                            sign: @signature
                          },
                          "Content-Type" => "application/x-www-form-urlencoded"
      JSON.parse r
    end

    def check_brand(vin)
      time = Util::Formatter.to_string_time(Time.zone.now)
      sign(uid + vin.to_s + time + pwd)
      r = RestClient.post host + "/rest/publicif/checkBrand",
                          { uid: uid, vin: vin, time: time, sign: @signature },
                          "Content-Type" => "application/x-www-form-urlencoded"
      JSON.parse r
    end

    def parse_and_persisted(oid)
      oid = "2168a29025a84d949c38b4c7e8b6232f" if Rails.env != "production"
      url = host + "/public/#{id_param}/web_publicReport?oid=#{oid}&uid=#{uid}&p=#{p}"

      doc = Nokogiri::HTML(open(url))
      attrs = parse_attributes(doc)
      hub = MaintenanceRecordHub.where(order_id: oid).first
      hub.assign_attributes(attrs)
      items = parse_items(doc)
      hub.items = items
      MaintenanceRecordHub.transaction do
        hub.save!
        hub.maintenance_records.update_all(
          vin: hub.vin, state: :unchecked
        )
      end
      hub
    end

    def parse_and_persisted_json(hub, data_hash)
      basic_attrs = parse_json_basic(data_hash)
      abstract_items = parse_json_resume(data_hash)
      detail_items = parse_json_details(data_hash)

      hub.assign_attributes(basic_attrs)
      hub.items = detail_items
      hub.abstract_items = abstract_items

      persist_hub(hub)
    end

    private

    def persist_hub(hub)
      MaintenanceRecordHub.transaction do
        hub.save!
        hub.maintenance_records.update_all(
          vin: hub.vin, state: :unchecked
        )
      end
      hub
    end

    def parse_json_basic(data_hash)
      basic_hash = data_hash.fetch("basic")

      field_attr_map = {
        vin: :vin,
        model: :style_name,
        brand: :brand,
        displacement: :displacement,
        gearbox: :transmission
      }

      attr_hash = {}
      field_attr_map.each_pair do |field, attri|
        attr_hash[attri] = sanitize_content(basic_hash.fetch(field.to_s))
      end

      attr_hash
    end

    def parse_json_details(data_hash)
      details_hash = data_hash.fetch("reportJson")

      details_hash.each_with_object([]) do |report_hash, acc|
        item_hash = {
          item: sanitize_content("项目：#{report_hash.fetch("content")}"),
          material: sanitize_content("材料：#{report_hash.fetch("material")}"),
          mileage: sanitize_content(report_hash.fetch("mileage")),
          date: sanitize_content(report_hash.fetch("repairDate")),
          category: sanitize_content(report_hash.fetch("type"))
        }
        acc << item_hash
      end
    end

    def parse_json_resume(data_hash)
      resume_hash = data_hash.fetch("resume")

      resume_hash.each_with_object({}) do |arr, hash|
        hash[arr.first] = transfer_resume_value(arr.last)
      end
    end

    def transfer_resume_value(v)
      case Integer(v)
      when 0
        "无异常记录"
      when 1
        "有异常记录"
      else
        v
      end
    rescue ArgumentError => _e
      v
    end

    # 解析基本信息部分
    def parse_attributes(doc)
      keys = {
        "VIN" => :vin,
        "报告时间" => :report_at,
        "车型" => :style_name,
        "品牌" => :brand,
        "变速器" => :transmission,
        "排气量" => :displacement
      }
      attrs = {}
      jibenxx = doc.css("#jibenxx")
      jibenxx.css(".m_m_bottom").each do |m_m_bottom|
        m_m_bottom1 = m_m_bottom.css(".m_m_bottom1")
        m_m_bottom1.xpath("li").map(&:content).each_slice(2) do |p|
          attrs[keys[p[0]]] = p[1] if keys[p[0]]
        end
      end
      attrs
    end

    # 解析具体内容部分
    def parse_items(doc)
      items = []

      item_keys = [:date, :mileage, :category, :item, :material]
      re_mleft = doc.css("#lishijl")
      re_mleft.css(".m_bot1").each do |m_bot1|
        item = {}
        m_bot1.css(".his1").each_with_index do |hi, hindex|
          case hindex
          when 0, 1, 2
            item[item_keys[hindex]] = hi.content.gsub(/[[:space:]]+/, "").strip
          when 3
            item_and_material = hi.content.gsub(/[[:space:]]+/, "").strip
            item_and_material = item_and_material.split("材料")
            item[:item] = item_and_material[0].strip
            item[:material] = "材料" + item_and_material[1].strip
          end
        end

        items << item
      end

      items
    end

    def sign(data)
      signature = rsa_private_key.sign "SHA1", data.force_encoding("utf-8")
      @signature = Base64.strict_encode64 signature
    end

    def verify(signature, data)
      rsa_public_key.verify("SHA1", Base64.strict_decode64(signature), data)
    end

    def sanitize_content(str)
      coder = HTMLEntities.new
      coder.decode(str)
    end
  end
end
