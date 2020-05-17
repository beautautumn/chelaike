class Customer < ActiveRecord::Base
  class ImportService
    include ErrorCollector
    attr_reader :filtered_phones

    def initialize(user, customers_params)
      @customers_params = customers_params
      @user = user
      @customer_phones = []
    end

    def execute
      # 过滤输入手机号之间的重复值
      filter_by_input
      # 过滤系统中手机号的重复值
      filter_by_data
      # 过滤参数
      filter_params
      # 导入
      customers = @customers_params.map do |p|
        if p[:name]
          p[:first_letter] = Pinyin.t(p[:name]) do |letters, i|
            letters[0].upcase if i == 0
          end
        end

        p.merge!(company_id: @user.company_id, user_id: @user.id, source: "imported")

        Customer.new(p)
      end
      Customer.import customers

      self
    end

    private

    def filter_params
      @customers_params.reject! do |p|
        customer_phones = [p[:phone], p[:phones]].flatten
        customer_phones.size != (customer_phones - @filtered_phones).size
      end
    end

    def filter_by_data
      @filtered_phones += filter_by_phones(@customer_phones)
      @filtered_phones &= @customer_phones
      @filtered_phones.uniq!
    end

    def filter_by_input
      @customers_params.map do |p|
        @customer_phones << p[:phone]
        @customer_phones += p[:phones]
      end
      @filtered_phones = @customer_phones
                         .group_by { |e| e }.select { |_k, v| v.size > 1 }.map(&:first)
      @customer_phones.uniq!
    end

    def filter_by_phones(phones)
      sql = phones.map { |p| "'#{p}' = ANY(phones)" }.join(" OR ")
      sql << " OR phone IN (#{phones.map { |e| "'#{e}'" }.join(",")})"

      Customer
        .where(user_id: @user.id, company_id: @user.company_id)
        .where(sql)
        .pluck(:phone, :phones)
        .flatten
    end
  end
end
