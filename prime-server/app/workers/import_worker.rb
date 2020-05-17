class ImportWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options retry: 1, queue: :migration

  def perform(user_id, link_id, job_key)
    RedisClient.current.incr(job_key)
    intercept(user_id, link_id)
    RedisClient.current.del(job_key)
  end

  def intercept(user_id, link_id)
    @error_urls = []
    current_user = User.find(user_id)

    car_import_service = Car::ImportService.new(current_user)

    car_links = car_import_service.car_links(link_id)

    # sidekiq 记录导入总数
    total car_links.size

    car_links.each.with_index(1) do |link, index|
      car_params = car_import_service.data_parse(link)
      import index,
             link,
             car_import_service,
             car_import_service.data_filter(car_params) if car_params.present?
    end

    store error_urls: @error_urls.join(",")
  end

  private

  def import(index, url, service, car_params)
    service.execute(car_params)
    at index
    @error_urls << url unless service.car.errors.empty?
  end
end
