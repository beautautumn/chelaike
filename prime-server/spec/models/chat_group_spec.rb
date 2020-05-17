# == Schema Information
#
# Table name: chat_groups
#
#  id            :integer          not null, primary key
#  organize_id   :integer                                      # 所属组织
#  organize_type :string                                       # 所属组织
#  name          :string           not null                    # 群组名称
#  state         :string           default("enable"), not null # 群组状态
#  group_type    :string           default("sale"), not null   # 群组类型
#  owner_id      :integer          not null                    # 群主
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  logo          :string                                       # 群组logo
#

require "rails_helper"

RSpec.describe ChatGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
