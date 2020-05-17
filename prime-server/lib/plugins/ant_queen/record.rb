module AntQueen
  class Record
    extend AntQueen::Request
    # 0:图片模式
    # 1:文字模式

    def self.query(brand_id:, vin:, is_vin:, order_id:, engine_num:, is_text:)
      path = "/OpenApi/query".freeze
      params = {
        token: AntQueen::Token.get,
        brand_id: brand_id,
        img_url: vin,
        order_id: order_id,
        is_text: is_text
      }
      params[:is_vin] = is_vin if is_vin
      params[:engine_num] = engine_num if engine_num
      result = ant_post(path: path, params: params)
      result
    end
  end
end
