class MaintenanceTimeoutWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(record_id, class_name)
    clazz = class_name.constantize
    record = clazz.find(record_id)

    record.process_timeout
  end
end
