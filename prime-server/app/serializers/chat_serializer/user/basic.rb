module ChatSerializer
  module User
    class Basic < ActiveModel::Serializer
      attributes :id, :nickname, :avatar, :phone, :rc_token,
                 :company_id, :company_name, :company_address,
                 :shop_id, :shop_name

      delegate :id, :name, :address, to: :company, prefix: true, allow_nil: true
      delegate :id, :name, to: :shop, prefix: true, allow_nil: true
      delegate :shop, :company, to: :object, allow_nil: true

      def nickname
        user_nickname = object.name || object.username

        company_nickname = instance_options[:company_nickname]
        return user_nickname unless instance_options[:company_nickname].present?

        "#{user_nickname}-#{company_nickname}"
      end
    end
  end
end
