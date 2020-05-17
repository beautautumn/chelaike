module CarPublisher
  class Che168Worker
    include Sidekiq::Worker
    sidekiq_options retry: false, queue: :publishers

    def perform(company_id, record_id, action = nil)
      publisher = PublisherWorker.new(company_id, record_id)

      action ||= publisher.record.che168_id.blank? ? :create : :update
      publisher.send(action)
    end
  end
end
