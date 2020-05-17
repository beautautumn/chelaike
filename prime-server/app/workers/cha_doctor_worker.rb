class ChaDoctorWorker
  include Sidekiq::Worker

  def perform(hub_id)
    # TODO: 访问接口，得到报告具体内容
    hub = ChaDoctorRecordHub.find(hub_id)
    ChaDoctorService::GetReport.execute(hub)
  end
end
