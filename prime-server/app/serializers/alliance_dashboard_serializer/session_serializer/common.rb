module AllianceDashboardSerializer
  module SessionSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :username, :authorities, :token, :created_at, :phone,
                 :name, :avatar, :settings

      belongs_to :alliance_company, serializer: AllianceCompanySerializer::Common

      # def director
      #   object.can?("全部客户管理") || User.exists?(manager_id: object.id)
      # end
    end
  end
end
