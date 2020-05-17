class DailyActiveService
  class << self
    def record_info_to_db(user_token, request_ip, url, params)
      begin
        token = user_token.match(/AutobotsAuth (.*)/).captures.first
      rescue
        return
      end

      user_id = JWT.decode(token, Rails.application.secrets[:secret_token])
                   .first.fetch("user_id")

      attrs = { user_id: user_id, request_ip: request_ip,
                url: url, company_id: User.with_deleted.find(user_id)[:company_id]
              }
              .merge(region_and_city(request_ip))
              .merge(path_query_hash(params))

      DailyActiveRecord.create!(attrs)
    end

    private

    def path_query_hash(params)
      controller = params.fetch("controller")
      action = params.fetch("action")
      query = params.except("controller", "action")

      {
        url_path: "#{controller}##{action}",
        url_query: query
      }
    end

    def region_and_city(request_ip)
      data = Util::IP.parse_ip(request_ip) || {}

      { region: data["region"], city: data["city"] }
    end
  end

  attr_reader :start_date, :end_date

  def initialize(start_date, end_date = nil)
    @start_date = Util::Date.parse_date_string(start_date).to_date
    @end_date = Util::Date.parse_date_string(end_date) || Time.zone.now.to_date.to_date
  end

  def valid_companies(city = nil)
    final_companies(city)
  end

  def company_dac(company_id)
    company = Company.find(company_id)
    calculate_company_dac(company)
  end

  private

  def final_companies(city = nil)
    where_sql = <<-SQL.squish!
      id in (
        select t1.id
        from (:valid_company_ids) t1
        where t1.id in (:valid_dau_company_ids)
      )
    SQL

    Company.where(where_sql,
                  valid_company_ids: valid_company_ids(city),
                  valid_dau_company_ids: valid_dau_company_ids
                 )
  end

  def valid_dau_company_ids
    scoped = DailyActiveRecord.select(:company_id)
                              .where("created_at between ? and ?",
                                     @start_date.beginning_of_day, @end_date.end_of_day
                                    )

    scoped.group(:company_id).having("count(id) >= 3").order(:company_id)
  end

  def valid_company_ids(city)
    where_sql = <<-SQL.squish!
                  (companies.created_at between :start_time and :end_time)
                  OR (
                    (companies.created_at <= :start_time)
                    AND
                    (companies.id in (:cars_count_company_ids))
                  )
                SQL
    scoped = Company.select(:id).where(where_sql,
                                       start_time: (@end_date - 7).beginning_of_day,
                                       end_time: @end_date.end_of_day,
                                       cars_count_company_ids: cars_count_company_ids
                                      )

    city.present? && scoped = scoped.where(city: city)
    scoped.order("companies.id")
  end

  def cars_count_company_ids
    Company.select(:id).joins(:in_stock_cars).group("companies.id").having("count(cars.id) >= 20")
  end

  def calculate_company_dac(company)
    records = DailyActiveRecord.where(company_id: company.id)
                               .where("created_at between :start_time and :end_time",
                                      start_time: @start_date.beginning_of_day,
                                      end_time: @end_date.end_of_day
                                     )
    total = records.count

    local, nonlocal = if company.city.present?
                        local = records.to_a.count { |r| r.city.start_with?(company.city) }
                        [local, total - local]
                      else
                        Array.new(2, 0)
                      end

    { total: total, local: local, nonlocal: nonlocal }
  end
end
