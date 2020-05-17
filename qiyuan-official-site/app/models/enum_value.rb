# frozen_string_literal: true
# == Schema Information
#
# Table name: enum_values
#
#  id              :integer          not null, primary key
#  name            :string                                 # 枚举值字面名称
#  value           :string                                 # 枚举值
#  additional_info :string                                 # 枚举值附加信息
#  enum_type_id    :integer                                # 枚举类型
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order           :integer                                # 枚举排序值
#

class EnumValue < ApplicationRecord
  belongs_to :enum_type
end
