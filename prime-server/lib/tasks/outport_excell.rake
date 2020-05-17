namespace :outport_excell do
  desc "outport call style information to excel"
  task car_styles: :environment do
    workbook = WriteExcel.new('car_styles.xls')

    worksheet = workbook.add_worksheet
    worksheet.set_column('B:B', 45)
    worksheet.set_column('C:C', 20)
    worksheet.set_row(0, 30)

    header = workbook.add_format
    header.set_bold
    header.set_size(12)
    header.set_color('black')
    header.set_align('center')

    worksheet.write(0, 0, '车型ID',  header)
    worksheet.write(0, 1, '车型名称',  header)
    worksheet.write(0, 2, '品牌ID',  header)
    worksheet.write(0, 3, '品牌名称',  header)
    worksheet.write(0, 4, '车系ID',  header)
    worksheet.write(0, 5, '车系名称',  header)
    worksheet.write(0, 6, '排量',  header)
    worksheet.write(0, 7, '变速箱',  header)
    worksheet.write(0, 8, '新车指导价',  header)
    worksheet.write(0, 9, '年款',  header)
    worksheet.write(0, 10, '类型',  header)

    row_index = 1
    brands = Megatron.brands.fetch("data")
    brands.each_with_index do |brand, brand_index|
      series = Megatron.series(brand.fetch("name")).fetch("data")
      series.each do |series|
        series.fetch("series").each_with_index do |series_detail, series_index|
          styles = Megatron.styles(series_detail.fetch("name")).fetch("data")
          styles.each do |style|
            year = style.fetch("year")
            models = style.fetch("models")
            models.each_with_index do |model, model_index|
              row_index += 1

              worksheet.write(row_index, 0, model.fetch("id"))
              worksheet.write(row_index, 1, model.fetch("name"))
              worksheet.write(row_index, 2, brand.fetch("_id"))
              worksheet.write(row_index, 3, brand.fetch("name"))
              worksheet.write(row_index, 4, series_detail.fetch("_id"))
              worksheet.write(row_index, 5, series_detail.fetch("name"))
              worksheet.write(row_index, 9, year)


              puts row_index

              style_detail = Megatron.style(series_detail.fetch("name"), model.fetch("name"), nil,nil).fetch("data")

              worksheet.write(row_index, 6, style_detail.fetch("car_configuration").try(:fetch, 0).try(:fetch, "fields").try(:fetch, 2).try(:fetch, "value"))
              style_detail.fetch("car_configuration").each do |config|
                if config.fetch("name") == "发动机"
                  config.fetch("fields").each do |fadongji|
                    if fadongji.fetch("name") == "排量(mL)"
                      worksheet.write(row_index, 6, fadongji.fetch("value"))
                    end
                  end
                end
              end

              style_detail.fetch("car_configuration").each do |config|
                if config.fetch("name") == "变速箱"
                  config.fetch("fields").each do |biansuxiang|
                    if biansuxiang.fetch("name") == "简称"
                      worksheet.write(row_index, 7,  biansuxiang.fetch("value"))
                    end
                  end
                end
              end
              worksheet.write(row_index, 8, style_detail.fetch("price").fetch("guide_price"))

            end
          end
        end
      end
    end

    workbook.close
  end

  desc "outport company debit to excel"
  task company_debit: :environment do
    workbook = WriteExcel.new('company_debit.xls')

    worksheet = workbook.add_worksheet

    worksheet.set_column('B:B', 30)
    worksheet.set_column('C:C', 15)
    worksheet.set_column('D:D', 15)
    worksheet.set_column('F:F', 15)
    worksheet.set_row(0, 30)

    header = workbook.add_format
    header.set_bold
    header.set_size(12)
    header.set_color('black')
    header.set_align('center')

    worksheet.write(0, 0, '公司 ID',  header)
    worksheet.write(0, 1, '公司名称',  header)
    worksheet.write(0, 2, '省份',  header)
    worksheet.write(0, 3, '城市',  header)
    worksheet.write(0, 4, '创建日期',  header)
    worksheet.write(0, 5, '注册人姓名',  header)
    worksheet.write(0, 6, '取整库存资金量',  header)
    worksheet.write(0, 7, '真实库存资金量',  header)
    worksheet.write(0, 8, '经营健康评级',  header)
    worksheet.write(0, 9, '综合评级',  header)
    worksheet.write(0, 10, '行业风评',  header)
    worksheet.write(0, 11, '资产负债率',  header)
    worksheet.write(0, 12, '资金周转率',  header)
    worksheet.write(0, 13, '利润率',  header)

    row_index = 1
    Company.all.each do |company|
      row_index += 1
      debit = EasyLoan::Debit.with_date_and_company(company, Time.now.year, Time.zone.now.month).first

      worksheet.write(row_index, 0, company.try(:id))
      worksheet.write(row_index, 1, company.try(:name))
      worksheet.write(row_index, 2, company.try(:province))
      worksheet.write(row_index, 3, company.try(:city))
      worksheet.write(row_index, 4, company.try(:created_at).strftime('%Y-%m'))
      worksheet.write(row_index, 5, company.try(:owner).try(:name))
      worksheet.write(row_index, 6, debit.try(:inventory_amount))
      worksheet.write(row_index, 7, debit.try(:real_inventory_amount))
      worksheet.write(row_index, 8, debit.try(:operating_health))
      worksheet.write(row_index, 9, debit.try(:comprehensive_rating))
      worksheet.write(row_index, 10, debit.try(:industry_rating))
      worksheet.write(row_index, 11, debit.try(:assets_debts_rating))
      worksheet.write(row_index, 12, debit.try(:cash_turnover_rate))
      worksheet.write(row_index, 13, debit.try(:car_gross_profit_rate))
      puts "outport #{company.name}'s debit done"
    end

    workbook.close
  end

  desc "把鑫长海在库资金导出"
  task changhai: :environment do
    company = Company.find(17)
    cars = company.cars.stock_by_month(Time.zone.now.last_month.beginning_of_month, Time.zone.now.last_month.end_of_month)

    workbook = WriteExcel.new('company_id_17.xls')

    worksheet = workbook.add_worksheet

    worksheet.set_column('B:B', 30)
    worksheet.set_column('C:C', 15)
    worksheet.set_column('D:D', 15)
    worksheet.set_column('F:F', 15)
    worksheet.set_row(0, 30)

    header = workbook.add_format
    header.set_bold
    header.set_size(12)
    header.set_color('black')
    header.set_align('center')

    worksheet.write(0, 0, '公司 ID',  header)
    worksheet.write(0, 1, '公司名称',  header)
    worksheet.write(0, 2, '在库车辆',  header)
    worksheet.write(0, 3, '收购价',  header)
    worksheet.write(0, 4, '车三百估值',  header)
    worksheet.write(0, 5, '品牌',  header)
    worksheet.write(0, 6, '车系',  header)
    worksheet.write(0, 7, '上牌日期',  header)
    worksheet.write(0, 8, '里程',  header)

    row_index = 1

    cars.inject do |_, car|
      row_index += 1
      worksheet.write(row_index, 0, company.try(:id))
      worksheet.write(row_index, 1, company.try(:name))
      worksheet.write(row_index, 2, car.try(:style_name))
      worksheet.write(row_index, 3, car.try(:acquisition_price_wan))
      worksheet.write(row_index, 4, nil)
      worksheet.write(row_index, 5, car.try(:brand_name))
      worksheet.write(row_index, 6, car.try(:series_name))
      worksheet.write(row_index, 7, car.try(:licensed_at))
      worksheet.write(row_index, 8, car.try(:mileage_in_fact))
    end
    workbook.close
  end
end
