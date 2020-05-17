# == Schema Information
#
# Table name: mortgage_companies # 按揭公司
#
#  id         :integer          not null, primary key # 按揭公司
#  company_id :integer                                # 公司ID
#  name       :string                                 # 名称
#  deleted_at :datetime                               # 删除时间
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module MortgageCompanySerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :company_id, :created_at
  end
end
