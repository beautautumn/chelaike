class EtlCarWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, queue: :etl

  ERBContext = Struct.new(:car_id) do
    def with_binding
      binding
    end
  end

  def perform(car_id)
    path = "#{Rails.root}/lib/plugins/etl/scripts/car.etl.erb"

    script_content = ERB.new(File.read(path)).result(ERBContext.new(car_id).with_binding)

    job_definition = Kiba.parse(script_content, path)
    Kiba.run(job_definition)
  end
end
