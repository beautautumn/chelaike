# rubocop:disable Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/MethodLength
class Reporter::ReportTypes::CarsOutOfStock
  attr_reader :user, :name

  def initialize(user, params)
    @user = user
    @name = "已出库车辆导出#{Time.zone.now.strftime("%Y%m%d")}.xls"
    @query = params[:query]
  end

  def export
    title_bar = %w(
      库存号 所属分店 车辆名称 上牌日期 里程(万) 排量 颜色 收购价(万) 经理底价(万) 销售底价(万)
      展厅标价(万) 收购人 车架号 原车牌号 车辆状态 库龄(天) 预定日期 收购日期 收购类型 销售成交价(万)
      销售员 销售日期 销售类型 客户来源 客户归属地区 客户姓名 电话 证件号码 付款方式 定金(万)
      余款(万) 按揭公司 首付款(万) 贷款额度(万) 收购过户费(元) 销售过户费(元) 佣金(元) 开票费(元)
      其他费用(元) 保险公司 商业险(元) 交强险(元)
    )

    HoneySheet::Excel.package(@name, title_bar, records)
  end

  def records
    Enumerator.new do |yielder|
      scope = Car.joins(:stock_out_inventory).where(company_id: user.company_id).uniq

      CarPolicy::Scope.new(user, scope)
                      .resolve
                      .ransack(@query)
                      .result
                      .state_out_of_stock_scope
                      .includes(:acquirer, :cooperation_companies, :acquisition_transfer,
                                :sale_record, :shop)
                      .order(:name_pinyin)
                      .order("cars.id desc, cars.updated_at desc")
                      .find_each(batch_size: 100) do |car|
        sale_record = car.sale_record

        record = [
          car.stock_number,
          car.shop.try(:name),
          car.system_name,
          car.licensed_at.try(:strftime, "%Y/%m/%d"),
          car.mileage,
          car.displacement_text,
          car.exterior_color,
          user.can?("收购价格查看") ? car.acquisition_price_wan : nil,
          user.can?("经理底价查看") ? car.manager_price_wan : nil,
          user.can?("销售底价查看") ? car.sales_minimun_price_wan : nil,
          car.show_price_wan,
          car.acquirer.try(:name),
          car.vin,
          car.acquisition_transfer.try(:original_plate_number),
          car.state_text,
          car.stock_age_days,
          car.car_reservation.try(:reserved_at).try(:strftime, "%Y/%m/%d"),
          car.acquired_at.try(:strftime, "%Y/%m/%d"),
          car.acquisition_type_text,
          user.can?("销售成交信息查看") ? sale_record.try(:closing_cost_wan) : nil,
          sale_record.try(:seller_id) ? sale_record.seller.try(:name) : nil,
          sale_record.try(:completed_at),
          sale_record.try(:sales_type_text)
        ]

        # 销售员本人 || 销售成交信息查看权限
        if sale_record && (sale_record.seller_id == user.id || user.can?("销售成交信息查看"))
          record << [
            sale_record.try(:customer_channel).try(:name),
            "#{sale_record.customer_location_province}-#{sale_record.customer_location_city}",
            sale_record.customer_name,
            sale_record.customer_phone,
            sale_record.customer_idcard
          ]
        else
          record << Array.new(4)
        end

        record << Array(sale_record.try(:payment_type_text))

        record << if sale_record && (sale_record.seller_id == user.id || user.can?("销售成交信息查看"))
                    [
                      sale_record.deposit_wan,
                      sale_record.remaining_money_wan
                    ]
                  else
                    Array.new(2)
                  end

        if sale_record && sale_record.mortgage? && user.can?("按揭信息查看")
          record << [
            sale_record.mortgage_company.try(:name),
            sale_record.down_payment_wan,
            sale_record.loan_amount_wan
          ]
        else
          record << Array.new(3)
        end

        record << if car.acquisition_transfer && user.can?("收购价格查看")
                    # 收购过户费
                    [car.acquisition_transfer.try(:transfer_fee_yuan)]
                  else
                    Array.new(1)
                  end

        if sale_record && (sale_record.seller_id == user.id || user.can?("销售成交信息查看"))
          record << [
            # 销售过户费, 佣金, 开票费用, 其他费用
            sale_record.transfer_fee_yuan,
            sale_record.commission_yuan,
            sale_record.invoice_fee_yuan,
            sale_record.other_fee_yuan
          ]
        else
          record << Array.new(4)
        end

        if sale_record && user.can?("保险信息查看")
          record << [
            sale_record.insurance_company.try(:name),
            sale_record.commercial_insurance_fee_yuan,
            sale_record.compulsory_insurance_fee_yuan
          ]
        else
          record << Array.new(3)
        end

        yielder << record.flatten
      end
    end
  end
end
# rubocop:enable Metrics/PerceivedComplexity, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/LineLength, Metrics/MethodLength
