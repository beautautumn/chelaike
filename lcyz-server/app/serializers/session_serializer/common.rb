module SessionSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :username, :authorities, :token, :created_at, :phone,
               :name, :avatar, :settings, :director, :mobile_app_car_detail_menu,
               :qrcode_url, :self_description, :rc_prefix

    belongs_to :shop, serializer: ShopSerializer::Common
    belongs_to :company, serializer: CompanySerializer::Common

    def director
      manager? || User.exists?(manager_id: object.id)
    end

    def rc_prefix
      rc_prefix = ENV["RC_PREFIX"] || ""
      "#{rc_prefix}_" if rc_prefix.present?
    end

    def manager?
      object.can?("全部客户管理") || object.can?("全部求购客户管理") || object.can?("全部出售客户管理")
    end
  end
end
