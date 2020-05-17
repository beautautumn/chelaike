# == Serializer for Car detail info, only used for dashboard


module Dashboard
  class CarDetail < ActiveModel::Serializer

    attributes :id, :company_id, :acquirer_id, :acquired_at, :shop_id,
             :channel_id, :acquisition_type, :cover_url,
             :stock_number, :vin, :state, :state_text, :state_note, :brand_name,
             :manufacturer_name, :series_name, :style_name, :name, :car_type,
             :door_count, :displacement, :fuel_type, :is_turbo_charger,
             :transmission, :exterior_color, :interior_color, :mileage,
             :mileage_in_fact, :level, :emission_standard, :license_info,
             :licensed_at, :manufactured_at, :show_price_wan, :online_price_wan,
             :new_car_guide_price_wan, :new_car_additional_price_wan, :new_car_discount,
             :new_car_final_price_wan, :interior_note, :star_rating, :warranty_id,
             :warranty_fee_yuan, :is_fixed_price, :allowed_mortgage, :mortgage_note,
             :selling_point, :maintain_mileage, :has_maintain_history, :red_stock_warning_days,
             :new_car_warranty, :created_at, :age, :sellable, :actual_states_statistic,
             :yellow_stock_warning_days, :state_changed_at, :reserved_at, :reserved,
             :reserved_days, :consignor_name, :consignor_phone, :consignor_price_wan,
             :stock_out_at, :closing_cost_wan, :predicted_restocked_at,
             :current_plate_number, :deleted_at, :system_name, :stock_age_days,
             :is_special_offer, :fee_detail, :cost_sum, :cost_statement

    attribute :acquisition_price_wan
    attribute :alliance_minimun_price_wan
    attribute :sales_minimun_price_wan
    attribute :manager_price_wan

    attribute :sync_state_text

    attribute :cooperation_company_relationships

    attributes :attachments, :configuration_note, :manufacturer_configuration, :viewed_count

    belongs_to :company, serializer: CompanySerializer::Common
    belongs_to :shop, serializer: ShopSerializer::Common
    belongs_to :channel, serializer: ChannelSerializer::Common
    belongs_to :warranty, serializer: WarrantySerializer::Common
    #belongs_to :acquirer, serializer: UserSerializer::Acquirer  收购信息不显示

    #has_one :acquisition_transfer,                              收购过户记录不显示
    #        serializer: TransferRecordSerializer::Acquisition
    # if: :can_read_transfer_records

    #has_one :sale_transfer,                                     销售过户记录不显示
    #        serializer: TransferRecordSerializer::Sale
    # if: :can_read_transfer_records

    #has_one :prepare_record, serializer: PrepareRecordSerializer::Common   整备记录不显示
    #has_one :car_reservation, serializer: CarReservationSerializer::Common  预定信息不显示
    has_one :stock_out_inventory, serializer: ::StockOutInventorySerializer::Mini

    has_many :images, serializer: ImageSerializer::Common
    has_many :alliance_images, serializer: ImageSerializer::Common, if: :alliance_images?

    #has_many :operation_records, serializer: OperationRecordSerializer::Common  操作记录不显示

    has_one :che168_publish_record, serializer: Che168PublishRecordSerializer::Syncable
    has_many :alliances, serializer: AllianceSerializer::Basic
    has_many :all_alliances, serializer: AllianceSerializer::Basic

    def alliance_images?
      instance_options[:alliance_images]
    end


    def displacement
      object.displacement.try(:to_s)
    end

    # 成本详情
    def cost_statement
      {
        acquisition_price: {
          name: "收购价",
          value: object.acquisition_price_wan,
          unit: "万元"
        },
        prepare_fee: {
          name: "整备费用",
          value: object.prepare_record.try(:total_amount_yuan),
          unit: "元"
        },
        license_transfer_fee: {
          name: "牌证过户费用",
          value: object.acquisition_transfer.try(:total_transfer_fee_yuan),
          unit: "元"
        }
      }
    end

    # 成本合计
    def cost_sum
      {
        name: "成本",
        value: object.cost_sum_wan,
        unit: "万元"
      }
    end

    def cooperation_company_relationships
        object.cooperation_company_relationships
              .eager_load(:cooperation_company).map do |relationship|
          cooperation_company = relationship.cooperation_company
          next if cooperation_company.blank?

          attributes = cooperation_company_relationship_attributes(relationship)

          attributes.tap do |result|
            result[:cooperation_company] = {
              id: cooperation_company.id,
              name: cooperation_company.name,
              company_id: cooperation_company.company_id,
              created_at: cooperation_company.created_at
            }
          end
        end.compact
    end

    def cooperation_company_relationship_attributes(relationship)
      {
        id: relationship.id,
        car_id: relationship.car_id,
        cooperation_company_id: relationship.cooperation_company_id,
        cooperation_company: {
          id: relationship.cooperation_company_id
        }
      }.tap do |hash|
        hash[:cooperation_price_wan] = relationship.cooperation_price_wan
      end
    end


  end
end
