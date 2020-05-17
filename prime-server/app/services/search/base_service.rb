module Search
  class BaseService
    def initialize(request, headers, params)
      @query = params[:query]
      @keyword = @query[:keyword]

      @current_page = params[:page].to_i
      @per_page = params[:per_page].to_i

      @links = (headers["Link"] || "").split(",").map(&:strip)
      @url = request.original_url.sub(/\?.*$/, "")
      @request = request
      @headers = headers

      @keyword_fields = []
      @rank_fields = []
      @filters_fields = {}
    end

    def keywords(*fields)
      @keyword_fields = []
      @keyword_fields.concat(fields).uniq!
    end

    def ranks(*fields)
      @rank_fields = []
      @rank_fields.concat(fields).uniq!
    end

    def filters(fields)
      @filters_fields = {}
      @filters_fields.merge!(fields)
    end

    def filters_query
      query = @filters_fields.map do |field, type|
        filters = []

        if @query["#{field}_gte"]
          filters << "#{field} >= #{filter_value(@query["#{field}_gte"], type)}"
        end

        if @query["#{field}_lte"]
          filters << "#{field} <= #{filter_value(@query["#{field}_lte"], type)}"
        end

        if @query["#{field}_eq"]
          filters << "#{field} = #{filter_value(@query["#{field}_eq"], type)}"
        end

        filters.join(" AND ")
      end.reject(&:empty?).join(" AND ")

      "&&filter=#{query}" unless query.empty?
    end

    def keywords_query
      return "''" unless @keyword

      @keyword_fields.map do |field|
        "#{field}: '#{@keyword}'"
      end.join(" OR ")
    end

    def ranks_query
      @rank_fields.map do |field|
        "RANK #{field}: '#{@keyword}'"
      end.join(" ")
    end

    def custom_condition
      ""
    end

    def open_search_params
      start = @per_page * (@current_page - 1)

      query = <<-QUERY
          query=( #{keywords_query} )
          #{custom_condition}
          #{ranks_query}
          #{filters_query}
      QUERY

      Rails.logger.debug query

      {
        query: [
          query.squish!,
          "config=start:#{start},hit:#{@per_page}"
        ],
        fetch_fields: :id
      }
    end

    private

    def set_headers
      links_hash.each do |rel, page_num|
        new_params = @request.query_parameters.merge(page: page_num)

        @links << %(<#{@url}?#{new_params.to_param}>; rel="#{rel}")
      end

      @headers["Link"] = @links.join(", ") unless @links.empty?
      @headers[ApiPagination.config.total_header] = @total.to_s
      @headers[ApiPagination.config.per_page_header] = @per_page.to_s
    end

    def links_hash
      @pages = @total.to_f / @per_page
      @pages = (@pages.to_i == @pages ? @pages : @pages + 1).to_i

      {}.tap do |hash|
        unless @current_page == 1
          hash["first"] = 1
          hash["prev"] = @current_page - 1
        end

        unless @current_page == @pages
          hash["last"] = @pages
          hash["next"] = @current_page + 1
        end
      end
    end

    def filter_value(field, type)
      value = "\"#{field}\"" if type == String
      value = field.to_s if type == Integer
      value = Time.zone.parse(field).to_i.to_s if type == Date

      value
    end
  end
end
