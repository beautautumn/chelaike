class Megatron
  def self.host
    ENV.fetch("MEGATRON_URL") + "/api/v1"
  end

  def self.brands
    JSON.parse Util::Request.get("#{host}/brands", timeout: 5)
  end

  def self.find_brand_by_name(brand_name)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/brands?brand[name]=#{brand_name}"), timeout: 5
    )
  end

  def self.find_brand_by_id(id)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/brands/#{id}"), timeout: 5
    )
  end

  def self.update_brand(id, brand)
    JSON.parse Util::Request.put(
      URI.escape("#{host}/brands/#{id}"), timeout: 5, brand: brand
    )
  end

  def self.create_brand(brand)
    JSON.parse Util::Request.post(
      URI.escape("#{host}/brands"), timeout: 5, brand: brand
    )
  end

  def self.series(brand_name)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/series/?brand[name]=#{brand_name}"), timeout: 5
    )
  end

  def self.a_series(series_name)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/series/?series[name]=#{series_name}"), timeout: 5
    )
  end

  def self.find_series_by_id(id)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/series/#{id}"), timeout: 5
    )
  end

  def self.create_series(series)
    JSON.parse Util::Request.post(
      URI.escape("#{host}/series"), timeout: 5, series: series
    )
  end

  def self.update_series(id, series)
    JSON.parse Util::Request.put(
      URI.escape("#{host}/series/#{id}"), timeout: 5, series: series
    )
  end

  def self.styles(series_name)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/styles?series[name]=#{series_name}"), timeout: 5
    )
  end

  def self.style_id(series_name, style_name)
    styles_map = styles(series_name).fetch("data").map { |item| item.fetch("models") }.flatten
    matched_item = styles_map.select { |item| item.fetch("name") == style_name }.first
    matched_item.fetch("id")
  end

  def self.style(series_name, style_name, province, city)
    url = "#{host}/styles?series[name]=#{series_name}&style[name]=#{style_name}&"
    url << "region[province]=#{province}&region[city]=#{city}"

    JSON.parse Util::Request.get(URI.escape(url), timeout: 5)
  end

  def self.style_present?(series_name, style_name)
    Megatron.style(series_name, style_name, "", "")["data"]["code"].present?
  end

  def self.brand(series_name)
    JSON.parse Util::Request.get(
      URI.escape("#{host}/brands?series[name]=#{series_name}"), timeout: 5
    )
  end
end
