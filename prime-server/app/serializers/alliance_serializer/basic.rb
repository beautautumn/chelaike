# == Schema Information
#
# Table name: alliances
#
#  id              :integer          not null, primary key
#  name            :string                                 # 联盟名称
#  owner_id        :integer                                # 所属公司ID
#  deleted_at      :datetime                               # 伪删除时间
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  active_tag      :boolean          default(FALSE)        # 活跃标识
#  honesty_tag     :boolean                                # 诚信标识
#  own_brand_tag   :boolean                                # 品牌商家标识
#  avatar          :string                                 # 联盟头像
#  note            :text                                   # 联盟说明
#  companies_count :integer                                # 公司数量
#

module AllianceSerializer
  class Basic < ActiveModel::Serializer
    attributes :id, :name, :avatar, :companies_count, :created_at,
               :honesty_tag, :own_brand_tag, :active_tag
  end
end
