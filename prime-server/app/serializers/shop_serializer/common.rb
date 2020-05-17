# == Schema Information
#
# Table name: shops # 店
#
#  id         :integer          not null, primary key # 店
#  name       :string                                 # 名称
#  company_id :integer                                # 所属公司
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime                               # 伪删除时间
#

module ShopSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :address, :company_id,
               :created_at, :phone, :province,
               :city, :weshop_name
  end
end
