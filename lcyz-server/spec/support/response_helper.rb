module ResponseHelper
  def response_json
    @response_json ||= MultiJson.load(response.body, symbolize_keys: true)
  end
end
