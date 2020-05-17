module Dashboard
  class DebitsController < ApplicationController
    before_action do
      authorize :dashboard_debit
    end

    # 发布评级页面
    def publish_page; end

    # 后台发布评级更新消息
    def publish
      user = ::User.find_by(username: "testmanager")

      debits_scope.each do |loan_debit|
        ::OperationRecord::CreateService.new(user).debit_updated_record(loan_debit)
      end

      redirect_to publish_page_debits_path, notice: "已发送"
    end

    private

    def debits_scope
      comprehensive_rating = params[:comprehensive_rating]
      inventory_amount = params[:inventory_amount]
      operating_health = params[:operating_health]
      industry_rating = params[:industry_rating]

      filter_sql = <<-SQL.squish!
         created_at between :start_time and :end_time
         and comprehensive_rating >= :comprehensive_rating
         and inventory_amount >= :inventory_amount
         and operating_health >= :operating_health
         and industry_rating >= :industry_rating
      SQL

      debits = EasyLoan::Debit.where(
        filter_sql,
        start_time: Time.zone.today.beginning_of_month.beginning_of_day,
        end_time: Time.zone.today.end_of_month.end_of_day,
        comprehensive_rating: comprehensive_rating,
        inventory_amount: inventory_amount,
        operating_health: operating_health,
        industry_rating: industry_rating
      )
    end
  end
end
