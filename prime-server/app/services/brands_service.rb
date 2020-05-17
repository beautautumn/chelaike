class BrandsService
  class << self
    # 提供官网使用得到所有品牌
    def official_cars_brands(scope)
      scope.where(sellable: true)
           .state_in_stock_scope
           .where("brand_name is not null")
           .where.not(brand_name: "")
           .select(:brand_name, "count(cars.id) AS cars_size")
           .group(:brand_name).order("cars_size desc")
           .map do |car|
             pinyin = Util::Brand.to_pinyin(car.brand_name)
             next if pinyin.blank?

             {
               first_letter: pinyin.upcase,
               name: car.brand_name,
               logo: top_brand_links.fetch(car.brand_name, "")
             }
           end
    end

    def official_cars_series(scope)
      scope.where(sellable: true)
           .state_in_stock_scope
           .where("brand_name is not null")
           .where.not(brand_name: "")
           .where("series_name is not null")
           .where.not(series_name: "")
           .select(:brand_name, :series_name, "count(cars.id) AS cars_size")
           .group(:brand_name, :series_name).order("cars_size desc")
           .map do |car|
             pinyin = Util::Brand.to_pinyin(car.series_name)
             next if pinyin.blank?

             {
               first_letter: pinyin.upcase,
               name: car.series_name,
               brand_name: car.brand_name
             }
           end
    end

    private

    def top_brand_links
      I18n.t("top_brands").with_indifferent_access
    end
  end
end
