module AllianceDashboardSerializer
  module ChannelSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :name, :company_id, :note, :created_at
    end
  end
end
