# frozen_string_literal: true
module Chelaike
  class SessionService
    def self.verification_code(phone, company_id)
      data = Chelaike::FetchService.get("/sessions/verification_code?phone=#{phone}", company_id)
      data[:msg]
    end

    def self.verify(phone, code, company_id)
      data = Chelaike::FetchService.post(
        "/sessions/verify",
        company_id,
        { phone: phone, code: code}
      )
      data[:msg]
    end
  end
end
