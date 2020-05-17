module ChaDoctorService
  class Util
    @user_id = ENV["CHA_DOCTOR_USER_ID"]
    @key_secret = ENV["CHA_DOCTOR_SECRET_KEY"]
    @cha_doctor_domain = "http://api.chaboshi.cn"

    class << self
      def get_request(api, attrs)
        url = "#{@cha_doctor_domain}#{api}"
        signed = signed_params(attrs)

        query_string = sort_params(signed)

        req = RestClient::Request.execute(
          method: :get,
          url: "#{url}?#{query_string}",
          timeout: 5)
        result = JSON.parse(req)
        result
      end

      def post_request(api, attrs)
        url = "#{@cha_doctor_domain}#{api}"
        signed = sort_params(signed_params(attrs))

        req = RestClient::Request.execute(
          method: :post,
          url: url,
          payload: signed,
          timeout: 5)
        result = JSON.parse(req)
        result
      end

      def signed_params(attrs)
        total_attrs = {
          timestamp: Time.zone.now.to_datetime.strftime("%Q"),
          nonce: SecureRandom.uuid,
          userid: @user_id
        }.merge(attrs)

        total_attrs = sanitized(total_attrs)

        signature = sign(total_attrs)

        total_attrs.merge(
          signature: signature
        )
      end

      def sanitized(attrs)
        attrs.delete_if do |_, value|
          value.blank?
        end

        attrs
      end

      def sign(attrs)
        sorted_params = CGI.escape(sort_params(attrs.clone))

        digest = OpenSSL::Digest.new("sha1")
        digested_signature = OpenSSL::HMAC.digest(
          digest, @key_secret, sorted_params
        )

        CGI.escape(Base64.encode64(digested_signature).strip)
      end

      def sort_params(attrs)
        arr = []
        attrs.each_pair do |key, value|
          arr << "#{key}=#{value}"
        end

        arr.sort.join("&")
      end
    end
  end
end
