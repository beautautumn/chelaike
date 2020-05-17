class PublicPraiseService
  attr_reader :parser, :car_model

  def initialize(brand_name, series_name, style_name)
    @parser = AutohomePublicPraise.parser

    @car_model = AutohomePublicPraise.car_model(
      brand_name, series_name, style_name
    )
  end

  def execute
    processing do
      sumup = parser.sumup(car_model.style_id)
      quality_problems = parser.quality_problems(car_model.series_id)
      sumup_record = find_sumup_record

      public_praises = collect_public_praises(sumup, sumup_record.exist_links)

      ActiveRecord::Base.connection.transaction do
        sumup_record.assign_attributes(
          car_model.to_h.merge(
            sumup: sumup,
            quality_problems: quality_problems,
            latest_exist_links: sumup_record.exist_links
          )
        )

        sumup_record.save!

        public_praises.each do |public_praise|
          PublicPraise::Record.create!(
            self.class.public_praise_attributes(sumup_record.id, public_praise)
          )
        end
      end

      PublicPraiseWorker.perform_async(sumup_record.id)
      sumup_record
    end
  end

  def processing_thread
    PublicPraise::Sumup.find_by(car_model.identity_ids)
  end

  def find_sumup_record
    PublicPraise::Sumup.find_or_initialize_by(car_model.identity_ids)
  end

  def processing
    RedisClient.current.set(mutex_key, 1)

    yield
  ensure
    RedisClient.current.del(mutex_key)
  end

  def collect_public_praises(sumup, latest_exist_links)
    links = sumup.fetch(:public_praises).fetch(:items) - latest_exist_links

    parser.public_praises(links, multi_thread: true)
  end

  def mutex_key
    @_mutex_key ||= "PublicPraiseService:#{car_model.uuid}"
  end

  def mutex_alive?
    RedisClient.current.get(mutex_key).present?
  end

  def self.public_praise_attributes(sumup_record_id, public_praise)
    content = public_praise.fetch(:content).fetch(:content)

    content_body = Hash[content.fetch(:body)]

    {
      sumup_id: sumup_record_id,
      link: public_praise.fetch(:link),
      logo: public_praise.fetch(:logo),
      username: public_praise.fetch(:username),
      content: public_praise.fetch(:content),
      most_satisfied: content_body["【最满意的一点】"],
      least_satisfied: content_body["【最不满意的一点】"],
      level: content.fetch(:level),
      viewed_count: content.fetch(:viewed_count),
      support_count: content.fetch(:support_count),
      created_at: public_praise.fetch(:created_at),
      updated_at: public_praise.fetch(:updated_at)
    }
  end

  # 更新以前已经抓取的口碑数据, 异步更新
  def self.update_histories(sumup_id)
    sumup_record = PublicPraise::Sumup.find(sumup_id)
    public_praises = AutohomePublicPraise.parser.public_praises(
      sumup_record.latest_exist_links, multi_thread: true
    )

    ActiveRecord::Base.connection.transaction do
      public_praises.each do |public_praise|
        link = public_praise.fetch(:link)

        record = PublicPraise::Record.find_by(link: link)

        next if record.blank? || record.updated_at.to_date == public_praise.fetch(:updated_at)

        record.update!(
          public_praise_attributes(sumup_id, public_praise)
        )
      end
    end
  end
end
