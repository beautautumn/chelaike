# == Schema Information
#
# Table name: user_chat_groups
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  chat_group_id :integer
#  nick_name     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe UserChatGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
