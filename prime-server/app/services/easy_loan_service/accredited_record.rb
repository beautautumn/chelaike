module EasyLoanService
  class AccreditedRecord
    attr_accessor :user, :accredited_record

    def initialize(user, accredited_record)
      @user = user
      @accredited_record = accredited_record
    end

    def create!
      @accredited_record.save!
      generate_operation_record
    end

    def create_or_update!
      existed_record = EasyLoan::AccreditedRecord.where(
        company_id: @accredited_record.company_id,
        funder_company_id: @accredited_record.funder_company_id
      ).first

      if existed_record
        existed_record.update!(
          limit_amount_wan: @accredited_record.limit_amount_wan,
          single_car_rate: @accredited_record.single_car_rate
        )
        @accredited_record = existed_record
      else
        @accredited_record.save!
      end

      generate_operation_record
    end

    private

    def generate_operation_record
      service = OperationRecord::CreateService.new(@user)
      service.accredited_updated_record(@accredited_record)
    end
  end
end
