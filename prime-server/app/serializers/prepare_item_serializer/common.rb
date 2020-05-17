# == Schema Information
#
# Table name: prepare_items # 整备项目
#
#  id                :integer          not null, primary key # 整备项目
#  name              :string                                 # 项目名
#  amount_cents      :integer                                # 费用
#  prepare_record_id :integer                                # 整备记录ID
#  note              :text                                   # 备注
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

module PrepareItemSerializer
  class Common < ActiveModel::Serializer
    include SerializerAuthorityHelper

    attributes :id, :name, :amount_yuan, :prepare_record_id, :note, :created_at,
               :updated_at

    def attributes(requested_attrs = nil, reload = false)
      attrs = super

      unless User::Pundit.filter(scope, object.prepare_record, ["整备费用查看"])
        attrs.except!(:amount_yuan)
      end

      attrs
    end
  end
end
