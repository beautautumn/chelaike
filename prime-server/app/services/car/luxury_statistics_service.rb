# 豪车统计
# 统计库存超过 90 天的豪车, 品牌包括: 宾利、劳斯莱斯、法拉利、兰博基尼、阿斯顿马丁
class Car < ActiveRecord::Base
  class LuxuryStatisticsService
    LUXURY_BRANDS = %w(宾利 劳斯莱斯 法拉利 兰博基尼 阿斯顿·马丁).freeze

    def initialize(stock_age_days)
      @stock_age_days = stock_age_days
    end

    def statistics
      return unless @stock_age_days

      file_name = "luxury_statistics.xls"
      @_file_path = "#{Rails.root}/log/#{file_name}"
      report = Spreadsheet::Workbook.new

      sheet = report.create_worksheet name: "车来客-豪车统计"
      sheet.row(0).concat %w(
        车辆ID 公司名称 地区 品牌 车系 款式 车况 库龄 收购价 售价
      )

      calculate_sheet(sheet)

      report.write @_file_path
    end

    def statistics_result_file
      statistics
      @_file_path
    end

    private

    def calculate_sheet(sheet)
      index = 0
      Car.where(brand_name: LUXURY_BRANDS)
         .includes(:company)
         .find_each(batch_size: 20) do |car|
        car_info = [
          car.id,                                             # 车辆 ID
          car.company.name,                                   # 公司名
          [car.company.province, car.company.city, car.company.district].join(" "), # 地区
          car.brand_name,                                     # 品牌
          car.series_name,                                    # 车系
          car.style_name,                                     # 款式
          "#{car.try(:licensed_at).try(:strftime, "%Y-%m")}, #{car.mileage} 万公里, \
外观 #{car.try(:exterior_color)}，内饰：#{car.try(:interior_color)}",
          car.stock_age_days,
          car.acquisition_price_wan,
          car.online_price_wan
        ]

        index += 1
        sheet.row(index).concat(car_info)
      end
    end
  end
end
