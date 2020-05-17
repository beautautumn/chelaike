module V1
  class TokenBillsController < ApplicationController
    before_action do
      authorize TokenBill
    end

    def index
      param! :token_type, String

      obj = case params[:token_type]
            when "user"
              current_user
            when "company"
              current_user.company
            end

      bills = TokenBill.get_bills(obj).order(created_at: :desc)
      arrs = bills.group_by(&:month_str)
      final_arr = []
      arrs.each do |arr|
        # TODO: 这里要判断一下是不是本月的数据，remaining要增加方法,得到历史记录
        final_arr << { arr.first => { records: arr.last.map(&:format_json),
                                      remaining: Token.get_token(obj).balance } }
      end

      render json: { data: final_arr }
    end
  end
end
