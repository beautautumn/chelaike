module Dw
  module Analysis
    class User < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = user_fields + [
          Fields.acquisition_count,
          Fields.acquisition_amount,
          Fields.acquisition_type,
          "COUNT(dw_acquisition_facts.id) AS acquisition_type_count"
        ]

        organize_acquisition_info(
          search_by(
            fact, fields, acquisition_dimensions.push(:acquirer), conditions,
            groups: ["users.id", Fields.acquisition_type],
            orders: "acquisition_count DESC NULLS LAST"
          )
        ).tap do |hash|
          hash[:total_acquisition_amount] = Dw::Analysis::Car.new(
            @company_id, shop_id: @shop_id
          ).acquisition_amount(conditions)
        end
      end

      def out_of_stock_info(conditions, target: "appraiser")
        fact = Dw::OutOfStockFact.state_out_of_stock.current

        sumup_fields = [
          Fields.out_stock_count,
          Fields.out_stock_amount,
          Fields.car_gross_profit,
          Fields.average_gross_profit
        ]

        fields = user_fields + sumup_fields

        organize_out_of_stock_info(
          search_by(
            fact, fields, dimensions_by_target(target), conditions,
            groups: "users.id",
            orders: "out_stock_amount DESC NULLS LAST"
          ), target
        ).tap do |hash|
          hash[:sumup] = Dw::Analysis::Car.new(@company_id, shop_id: @shop_id)
                                          .out_stock_info(conditions)
        end
      end

      def dimensions_by_target(target)
        return out_of_stock_dimensions.push(:seller) if target.to_s == "seller"

        [
          :stock_out_at_dimension,
          car_dimension: [acquisition_fact: :acquirer]
        ]
      end

      def organize_acquisition_info(result)
        acquisition_types = {}
        exist_user_ids = []

        result = result.group_by { |record| record["id"] }.map do |id, records|
          first_record = records.first
          exist_user_ids << id

          first_record.slice(*USER_FIELDS).tap do |hash|
            acquisition_count = 0
            acquisition_amount = 0.0

            hash["acquisition_type_statistic"] = {}.tap do |statistic|
              records.each do |record|
                acquisition_type = record.fetch("acquisition_type")
                acquisition_type_count = record.fetch("acquisition_type_count").to_i

                acquisition_count += record["acquisition_count"].to_i
                acquisition_amount += record["acquisition_amount"].to_f

                acquisition_types[acquisition_type] = Util::Math::Addition.execute(
                  acquisition_types[acquisition_type], acquisition_type_count
                )

                statistic[acquisition_type] = acquisition_type_count
              end
            end

            hash[:acquisition_count] = acquisition_count
            hash[:acquisition_amount] = acquisition_amount
          end
        end

        {
          acquisition_types: acquisition_types,
          other_users: other_users(exist_user_ids, %w(出售客户管理 出售客户跟进)),
          detail: result
        }
      end

      def organize_out_of_stock_info(result, target)
        exist_user_ids = []

        result = result.map do |record|
          exist_user_ids << record.fetch("id")

          record.slice(*USER_FIELDS).merge(
            out_stock_count: record.fetch("out_stock_count").to_i,
            out_stock_amount: record.fetch("out_stock_amount").to_f,
            car_gross_profit: record.fetch("car_gross_profit").to_f,
            average_gross_profit: record.fetch("average_gross_profit").to_f
          )
        end

        {
          detail: result,
          other_users: other_users(exist_user_ids, authorities_by_target(target))
        }
      end

      def other_users(exist_user_ids, authorities)
        scope = if @shop_id.present?
                  ::User.where(shop_id: @shop_id)
                else
                  ::User.where(company_id: @company_id)
                end

        scope.where.not(id: exist_user_ids)
             .authorities_any(*authorities)
             .authorities_without("库存统计查看")
             .select(*USER_FIELDS)
             .as_json
      end

      def authorities_by_target(target)
        return %w(出售客户管理 出售客户跟进) if target.to_s == "appraiser"

        %w(求购客户跟进 求购客户管理)
      end
    end
  end
end
