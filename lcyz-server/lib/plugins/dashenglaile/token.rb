module Dashenglaile
  class Token
    extend Dashenglaile::Request

    def self.get
      result = dasheng_post(
        sign: true,
        interface: "query_account_balance"
      )
      raise Dashenglaile::Error::Token if result.blank?
      result["balance"].to_f
    end
  end
end
