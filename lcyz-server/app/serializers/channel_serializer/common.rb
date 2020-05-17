# == Schema Information
#
# Table name: channels # 渠道设置
#
#  id         :integer          not null, primary key # 渠道设置
#  company_id :integer                                # 公司ID
#  name       :string                                 # 名称
#  note       :text                                   # 备注
#  deleted_at :datetime                               # 删除时间
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module ChannelSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :company_id, :note, :created_at, :company_type
  end
end
