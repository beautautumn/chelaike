# == Schema Information
#
# Table name: owner_companies # 归属车商
#
#  id         :integer          not null, primary key # 归属车商
#  name       :string                                 # 车商名
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  shop_id    :integer                                # 车商所属的分店
#  company_id :integer                                # 所属车商
#

require 'rails_helper'

RSpec.describe OwnerCompany, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
