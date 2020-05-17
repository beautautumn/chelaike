ApiPagination.configure do |config|
  config.total_header = 'X-Total'

  config.per_page_header = 'X-Per-Page'
end
