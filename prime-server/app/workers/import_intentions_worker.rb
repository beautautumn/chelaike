class ImportIntentionsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :migration

  def perform(record_id)
    record = ImportTask.find(record_id)

    service = Intention::ImportService.new(record)

    begin
      service.execute
    rescue StandardError => e
      ExceptionNotifier.notify_exception(e) if Rails.env.production?

      raise(e)
    end
  end
end
