module TimeHelper
  def iso8601_format(time = Time.zone.now)
    time = time.is_a?(String) ? Time.zone.parse(time) : time
    ActiveSupport::JSON.encode(time).delete("\"")
  end
end
