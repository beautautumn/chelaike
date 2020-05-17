module V1
  class TokensController < ApplicationController
    before_action do
      authorize Token
    end

    # 得到个人及公司车币数量，以及各查询平台需要消费的车币
    # deprecated
    # rubocop:disable Metrics/AbcSize
    def index
      param! :brand_id, Integer
      param! :ant_queen_record_id, Integer
      param! :platform_code, Integer
      # 1: 蚂蚁；2: 查博士；3: 大圣; 4: 车鉴定

      token = Token.get_token(current_user.company)
      user_token = Token.get_token(current_user)

      fetch_record_brand_id = lambda do
        if params[:ant_queen_record_id]
          AntQueenRecord.find(params[:ant_queen_record_id]).car_brand_id
        end
      end

      platform_code = params[:platform_code]
      ant_brand_id = params[:brand_id] || fetch_record_brand_id.call if platform_code == 1
      dasheng_brand_id = params[:brand_id] if platform_code == 3

      response_data = {
        data: {
          balance: token.try(:balance).to_f,
          user_balance: user_token.try(:balance).to_f,
          maintenance_record_price: MaintenanceRecord.unit_price.to_f,
          ant_queen_record_price: AntQueenRecord.unit_price(
            car_brand_id: ant_brand_id,
            company: current_user.company
          ),
          dashenglaile_record_price: DashenglaileRecord.unit_price(
            car_brand_id: dasheng_brand_id,
            company: current_user.company
          ),
          cha_doctor_price: ChaDoctorRecord.unit_price.to_f
        }
      }

      render json: response_data, scope: nil
    end

    # 得到个人及公司车币数量，以及各查询平台需要消费的车币
    def new_index
      param! :brand_id, Integer
      param! :record_id, Integer
      param! :platform_code, Integer
      # 1: 蚂蚁；2: 查博士；3: 大圣; 4: 车鉴定; 5: 老司机

      token = Token.get_token(current_user.company)
      user_token = Token.get_token(current_user)

      consume_token, remaining = from_token(token, user_token)
      response_data = {
        data: {
          balance: token.try(:balance).to_f,
          user_balance: user_token.try(:balance).to_f,
          token_type: consume_token.token_type,
          is_enough: remaining >= 0,
          remaining: remaining,
          consume_price: consume_price
        }.merge(platform_prices)
      }

      render json: response_data, scope: nil
    end

    # 返回个人及公司车币数量
    def all
      company_token = Token.get_or_create_token!(current_user.company)
      user_token = Token.get_or_create_token!(current_user)

      response_data = {
        company_token: company_token.format_balance,
        user_token: user_token.format_balance
      }

      render json: { data: response_data }, scope: nil
    end

    private

    def platform_prices
      @_prices ||= {
        maintenance_record_price: MaintenanceRecord.unit_price.to_d,
        ant_queen_record_price: AntQueenRecord.unit_price(
          car_brand_id: ant_brand_id,
          company: current_user.company
        ),
        dashenglaile_record_price: DashenglaileRecord.unit_price(
          car_brand_id: dasheng_brand_id,
          company: current_user.company
        ),
        cha_doctor_price: ChaDoctorRecord.unit_price.to_d,

        old_driver_record_price: OldDriverRecord.unit_price.to_d
      }
    end

    def platform_maps
      {
        "1" => "ant_queen_record_price",
        "2" => "cha_doctor_price",
        "3" => "dashenglaile_record_price",
        "4" => "maintenance_record_price",
        "5" => "old_driver_record_price"
      }
    end

    def from_token(token, user_token)
      price = consume_price
      return_token = if user_token.balance >= price
                       user_token
                     else
                       token
                     end

      remaining = return_token.balance - price
      [return_token, remaining]
    end

    def consume_price
      platform_prices.fetch(
        platform_maps.fetch(params[:platform_code].to_s, "cha_doctor_price").to_sym)
    end

    def ant_brand_id
      return unless params[:platform_code] == 1
      params[:brand_id] ||
        AntQueenRecord.find(params[:record_id]).car_brand_id
    end

    def dasheng_brand_id
      return unless params[:platform_code] == 3
      params[:brand_id] ||
        DashenglaileRecord.find(params[:record_id]).car_brand_id
    end
  end
end
