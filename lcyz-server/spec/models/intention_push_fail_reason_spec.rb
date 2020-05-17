# == Schema Information
#
# Table name: intention_push_fail_reasons # 意向跟进失败原因
#
#  id         :integer          not null, primary key # 意向跟进失败原因
#  company_id :integer                                # 公司id
#  note       :text                                   # 备注
#  name       :string                                 # 失败原因名
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe IntentionPushFailReason, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
