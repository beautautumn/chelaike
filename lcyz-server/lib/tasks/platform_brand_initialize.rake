namespace :platform_brand_initialize do
  desc "平台品牌初始化信息"
  task run: :environment do
    record_array = []

    # 蚂蚁女王 platform_code => 1
    brand_array = %w(奥迪 宝马 北京现代 玛莎拉蒂 华晨宝马 道奇 进口大众 捷豹 JEEP 广汽丰田 上汽大众 东风本田 克莱斯勒 路虎 MINI 东风悦达起亚 一汽丰田 斯巴鲁 英菲尼迪 斯柯达 别克 一汽马自达 凯迪拉克 一汽大众 东风雪铁龙 东风标致 海马 雪佛兰 广汽菲亚特 奇瑞 江淮 长安铃木 长安汽车 吉利 长安马自达 日产 长城 雷克萨斯 荣威 保时捷 广汽菲克 MG 进口丰田 沃尔沃亚太 进口丰田 进口菲亚特 长安沃尔沃 东风日产 进口马自达 奇瑞捷豹路虎 进口沃尔沃 启辰 尼桑 全球鹰 帝豪 东风英菲尼迪 英伦 哈弗 福特 进口日产)
    brand_array.each do |brand|
      record_array << { platform_code: 1, brand_name: brand, start_time: "09:00", end_time: "20:00", mode: "text"}
    end

    brand_array = %w(奥迪 宝马 北京现代 广汽丰田 上汽大众 道奇 进口大众 捷豹 JEEP 东风悦达起亚 一汽丰田 东风本田 克莱斯勒 路虎 MINI 一汽马自达 东风标致 斯巴鲁 别克 斯柯达 海马 长安铃木 纳智捷 一汽大众 雪佛兰 凯迪拉克 帝豪 长安马自达 保时捷 东风雪铁龙 吉利 全球鹰 众泰 东风风神 奇瑞捷豹路虎 启辰 荣威 奔腾 福特 进口英菲尼迪 英伦 沃尔沃 MG 比亚迪 进口丰田 进口马自达 郑州日产 江淮 长安轿车 东风英菲尼迪 奇瑞 东风日产 尼桑 日产 北京汽车 雷克萨斯 长城 哈弗)
    brand_array.each do |brand|
      record_array << { platform_code: 1, brand_name: brand, start_time: "09:00", end_time: "20:00", mode: "mix"}
    end

    brand_array = %w(东南三菱 福建奔驰 广汽三菱 开瑞 凯翼 长安商用 宝骏 红旗 DS 广汽传祺 雷诺)
    brand_array.each do |brand|
      record_array << { platform_code: 1, brand_name: brand, start_time: "09:00", end_time: "18:00", mode: "mix"}
    end

    # 查博士 platform_code => 2
    brand_array = %w(阿斯顿·马丁 奥迪 奥迪（进口） 保时捷 北京 北汽绅宝 北汽威旺 奔驰 比亚迪 标志 别克 长安 长安商用 长城 DS DS（进口） 大众 大众 大众 道奇 东风风神 东南 菲亚特 菲亚特（进口） 福特 福特（进口） 观致 广汽传祺 哈弗 海马 红旗 华泰 华泰新能源 Jeep Jeep（进口） 吉利 江淮 金杯 开瑞 凯迪拉克 凯迪拉克（进口） 凯翼 克莱斯勒 雷诺 雷诺（进口） 理念 铃木 铃木（进口） MG 马自达 马自达 马自达（进口） 欧朗 奇瑞 奇瑞新能源 启辰 起亚 日产 日产（进口） 荣威 smart 三菱 三菱 思铭 斯巴鲁 斯柯达 威麟 沃尔沃 沃尔沃（进口） 五菱 现代 雪佛兰 雪铁龙 英菲尼迪 英菲尼迪（进口） 中华 众泰 众泰大迈)
    brand_array.each do |brand|
      record_array << { platform_code: 2, brand_name: brand, start_time: "00:00", end_time: "24:00"}
    end

    brand_array = %w(宾利 GMC 法拉利 玛莎拉蒂 兰博基尼 劳斯莱斯)
    brand_array.each do |brand|
      record_array << { platform_code: 2, brand_name: brand, start_time: "09:00", end_time: "18:00"}
    end

    record_array << { platform_code: 2, brand_name: "巴博斯", start_time: "08:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "宝马", start_time: "09:00", end_time: "22:00"}
    record_array << { platform_code: 2, brand_name: "宝马（进口）", start_time: "09:00", end_time: "22:00"}
    record_array << { platform_code: 2, brand_name: "奔驰", start_time: "08:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "奔驰（福建奔驰）", start_time: "08:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "奔驰（进口）", start_time: "08:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "奔腾", start_time: "06:00", end_time: "20:00"}
    record_array << { platform_code: 2, brand_name: "本田", start_time: "07:00", end_time: "23:00"}
    record_array << { platform_code: 2, brand_name: "本田", start_time: "07:00", end_time: "23:00"}
    record_array << { platform_code: 2, brand_name: "本田（进口）", start_time: "07:00", end_time: "23:00"}
    record_array << { platform_code: 2, brand_name: "丰田", start_time: "08:00", end_time: "20:00"}
    record_array << { platform_code: 2, brand_name: "丰田", start_time: "08:00", end_time: "20:00"}
    record_array << { platform_code: 2, brand_name: "丰田", start_time: "08:00", end_time: "20:00"}
    record_array << { platform_code: 2, brand_name: "捷豹", start_time: "03:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "克莱斯勒", start_time: "08:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "雷克萨斯", start_time: "09:00", end_time: "19:00"}
    record_array << { platform_code: 2, brand_name: "路虎", start_time: "03:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "路虎", start_time: "03:00", end_time: "21:00"}
    record_array << { platform_code: 2, brand_name: "MINI", start_time: "09:00", end_time: "22:00"}

    # 大圣来了 platform_code => 3
    brands = Dashenglaile::Brand.get
    brands.each do |brand|
      next if [125, 127].include?(brand["brand_id"].to_i)
      record_array << { platform_code: 3, brand_name: brand["brand_name"],
                        price: brand["brand_price"], brand_code: brand["brand_id"],
                        need_engine_number: brand["is_need_engine_number"],
                        start_time: brand["query_start_time"],
                        end_time: brand["query_end_time"], status: true}
    end
    # 车鉴定 platform_code => 4 默认全部 8：30-20：00

    # 插入所有记录
    PlatformBrand.create(record_array)
  end
end
