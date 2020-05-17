module AcquisitionCarCommentSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :commenter_id, :company_id,
               :acquisition_car_info_id, :valuation_wan,
               :cooperate, :is_seller, :created_at, :updated_at,
               :note_text, :note_audios
    attributes :commenter_name, :company_name, :commenter_avatar

    def created_at
      Util::Datetime.date_with_time_format(object.created_at)
    end

    def company_name
      object.company.name
    end

    def commenter_avatar
      object.commenter.avatar
    end

    def commenter_name
      object.commenter.name
    end
  end
end
