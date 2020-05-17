class EasyLoan::LoanBillsController < EasyLoan::ApplicationController
  before_action :set_bill, only: [:show, :update]
  def index
    basic_params_validations

    bills = EasyLoan::LoanBill.ransack(params[:query])
                              .result.joins(:car)
                              .includes(:company, :car)
                              .order(created_at: :desc)
    bills = paginate policy_scope(bills)

    render json: bills,
           each_serializer: EasyLoanSerializer::LoanBillSerializer::Common,
           root: "data"
  end

  def show
    render json: @bill,
           serializer: EasyLoan::LoanBillSerializer::Detail,
           show_company: true,
           root: "data"
  end

  def update
    state = loan_bill_params[:state]
    note = loan_bill_params[:latest_note]
    amount_wan = loan_bill_params[:borrowed_amount_wan]
    state_change(amount_wan, state, note)
    render json: { data: { message: "success" } }
  end

  def create; end

  def brands
    brands = model_scope.where("brand_name is not null")
                        .select(:brand_name).distinct
                        .select { |car| car.brand_name.present? }
                        .map do |car|
      pinyin = Util::Brand.to_pinyin(car.brand_name)
      next if pinyin.blank?

      {
        first_letter: pinyin.upcase,
        name: car.brand_name
      }
    end

    render json: { data: brands.compact.sort_by! { |e| e[:first_letter] } }, scope: nil
  end

  def brand_and_series
    cars_scope = model_scope
    all_brands = BrandsService.official_cars_brands(cars_scope)
    brands = all_brands.map.with_index do |brand, i|
      ret = brand.to_h
      ret[:is_hot] = i <= 8
      ret
    end

    all_series = BrandsService.official_cars_series(cars_scope)
    series = all_series.map.with_index do |serie, i|
      ret = serie.to_h
      ret[:is_hot] = i <= 12
      ret
    end

    render json: {
      brands: brands,
      series: series
    }, scope: nil
  end

  private

  def model_scope
    scope = Car.where(id: current_user.sp_company.loan_bills.pluck(:car_id))
    scope
  end

  def loan_bill_params
    params.require(:loan_bill).permit(
      :company_id, :car_id, :sp_company_id, :funder_company_id, :state,
      :apply_code, :borrowed_amount_wan, :latest_note
    )
  end

  def set_bill
    @bill = EasyLoan::LoanBill.includes(
      :car, :company, :sp_company, :funder_company, :loan_bill_histories
    ).where(id: params[:id]).first
  end

  def state_change(amount_wan, state, note)
    service = EasyLoanService::LoanBill.new(current_user, @bill)

    service.change_state!(
      state: state,
      borrowed_amount_wan: amount_wan,
      note: note
    )
  end
end
