# == Schema Information
#
# Table name: prepare_records # 整备管理记录
#
#  id                     :integer          not null, primary key # 整备管理记录
#  car_id                 :integer                                # 车辆ID
#  state                  :string                                 # 整备状态
#  total_amount_cents     :integer                                # 费用合计
#  start_at               :date                                   # 开始时间
#  end_at                 :date                                   # 结束时间
#  repair_state           :string                                 # 维修现状
#  note                   :text                                   # 补充说明
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  preparer_id            :integer                                # 整备员ID
#  shop_id                :integer                                # 分店ID
#  estimated_completed_at :date                                   # 预计完成时间
#

module PrepareRecordSerializer
  class Common < ActiveModel::Serializer
    include SerializerAuthorityHelper

    attributes :id, :state, :total_amount_yuan, :start_at, :end_at, :repair_state,
               :note, :created_at, :updated_at, :car_id, :estimated_completed_at

    belongs_to :preparer, serializer: UserSerializer::Basic

    def attributes(requested_attrs = nil, reload = false)
      attrs = super

      can_edit = authority_filter("整备信息录入")
      can_read = authority_filter("整备信息查看")
      can_read_or_edit = can_edit || can_read

      if object && can_read_or_edit
        prepare_item_amount_authority = can_edit || User::Pundit.filter(scope, object, "整备费用查看")

        attrs[:prepare_items] = prepare_items(prepare_item_amount_authority)
      else
        attrs.except!(:total_amount_yuan)
      end

      attrs
    end

    def prepare_items(authority)
      object.prepare_items.map do |prepare_item|
        record = {
          id: prepare_item.id,
          name: prepare_item.name,
          prepare_record_id: prepare_item.prepare_record_id,
          note: prepare_item.note,
          created_at: prepare_item.created_at,
          updated_at: prepare_item.updated_at
        }

        record[:amount_yuan] = prepare_item.amount_yuan if authority

        record
      end
    end
  end
end
