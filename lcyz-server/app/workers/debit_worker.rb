class DebitWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    Company.all.each do |company|
      EasyLoanService::Calculate.new(company.id, Time.zone.today).update_debit if company.id != 1740
      Rails.logger.info "init #{company.name}'s debit done"
    end
  end
end
