module EasyLoan
  class AccreditedRecordsController < EasyLoan::ApplicationController
    def index
      param! :state, :boolean
      basic_params_validations
      companies = companies(params[:state])
      companies = paginate companies
                  .ransack(params[:query]).result
                  .order(updated_at: :desc)
      render json: companies,
             each_serializer: CompanySerializer::WithAccreditedRecord,
             root: "data"
    end

    # create or update
    def create
      company_id = accredited_records_params[:company_id]
      accredited_records_params[:accredited_records].each do |record_params|
        record_params = record_params.merge(
          company_id: company_id,
          sp_company_id: EasyLoan::SpCompany.first.id
        )
        accredited_record = EasyLoan::AccreditedRecord.new(record_params)

        EasyLoanService::AccreditedRecord.new(current_user, accredited_record).create_or_update!
      end
      render json: { data: { message: true } }, scope: nil, status: 200, root: "data"
    end

    private

    def accredited_records_params
      params.require(:records).permit(
        :company_id,
        :state,
        accredited_records: [:limit_amount_wan, :funder_company_id, :single_car_rate]
      )
    end

    def companies(credit_state = true)
      if credit_state.nil? || credit_state
        Company.includes(:accredited_records)
               .where(id: EasyLoan::AccreditedRecord.pluck(:company_id).uniq)
      else
        Company.includes(:accredited_records)
               .where.not(id: EasyLoan::AccreditedRecord.pluck(:company_id).uniq)
      end
    end
  end
end
