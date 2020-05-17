namespace :platform_brand_update do
  desc "更新蚂蚁女王平台品牌相关信息"
  task ant_queen: :environment do
    # 根据品牌名称和is_text去对接
    (AntQueen::Brand.get + AntQueen::Brand.get(is_text: 1)).each do |brand_info|
      is_text = brand_info["is_text"].to_i == 0 ? "mix" : "text"
      brand = PlatformBrand.where(brand_name: brand_info["name"],
                                  mode: is_text, platform_code: 1).first
      next unless brand.present?
      brand.update_attributes(price: brand_info["query_price"],
                              brand_code: brand_info["id"],
                              need_engine_number: brand_info["is_engine"],
                              status: true) unless brand.price.present?
    end
  end

  desc "更新大圣来了品台品牌相关信息"
  task dashenglaile: :environment do
    brand_infos = Dashenglaile::Brand.get
    brand_infos.each do |brand_info|
      brand = PlatformBrand.where(brand_code: brand_info["brand_id"], platform_code: 3).first
      next unless brand.present?
      brand.update_attributes!(price: brand_info["brand_price"],
                               need_engine_number: brand_info["is_need_engine_number"],
                               start_time: brand_info["query_start_time"],
                               end_time: brand_info["query_end_time"],
                               status: true) unless brand.price.present?
    end
  end

  desc "更新查博士平台相关信息"
  task doctor: :environment do
    PlatformBrand.where(platform_code: 2).each do |brand|
      # 设置默认价格为1
      brand.update_attributes(price: 15, status: true) unless brand.price.present?
    end
  end

  desc "最新价格更新 2017-01-11"
  task update_price: :environment do
    # 蚂蚁女王 图文19，文字11
    PlatformBrand.where(platform_code: 1).each do |brand|
      next unless brand.price.present?
      if brand.mode == "mix"
        brand.update_attributes(price: 19)
      elsif brand.mode == "text"
        brand.update_attributes(price: 11)
      end
    end

    # 查博士 14
    PlatformBrand.where(platform_code: 2).each do |brand|
      brand.update_attributes(price: 14) if brand.price.present?
    end

    # 大圣来了除了100之外，都是29
    PlatformBrand.where(platform_code: 3).each do |brand|
      brand.update_attributes(price: 29) if brand.price.present? && brand.price != 100
    end

    # 车鉴定 16
    PlatformBrand.where(platform_code: 4).each do |brand|
      brand.update_attributes(price: 16) if brand.price.present?
    end
  end
end
