class PublicPraiseWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(id)
    PublicPraiseService.update_histories(id)
  end
end
