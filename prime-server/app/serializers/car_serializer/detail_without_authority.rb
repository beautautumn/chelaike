module CarSerializer
  class DetailWithoutAuthority < ActiveModel::Serializer
    include CarSerializer::ConcernWithoutAuthority

    attributes :attachments, :configuration_note, :manufacturer_configuration, :viewed_count

    attributes :acquisition_transfer, :sale_transfer, :operation_records, :images, :prepare_record

    attribute :weshop_url

    has_one :acquisition_transfer,
            serializer: TransferRecordSerializer::Acquisition
    # if: :can_read_transfer_records

    has_one :sale_transfer,
            serializer: TransferRecordSerializer::Sale
    # if: :can_read_transfer_records

    has_one :prepare_record, serializer: PrepareRecordSerializer::Common

    has_many :images, serializer: ImageSerializer::Common

    has_many :operation_records, serializer: OperationRecordSerializer::Common

    def acquisition_price_wan?
      true
    end

    def alliance_minimun_price_wan?
      true
    end

    def sales_minimun_price_wan?
      true
    end

    def manager_price_wan?
      true
    end

    def acquisition_info?
      true
    end

    def weshop_url
      domain_id = "domain_#{object.company_id}"
      company_domain = @instance_options[:company_domain_hash][domain_id]
      "#{company_domain}/cars/#{object.id}"
    end
  end
end
