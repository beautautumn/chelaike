# frozen_string_literal: true
# == Schema Information
#
# Table name: enum_types
#
#  id              :integer          not null, primary key
#  name            :string                                 # 枚举类型的名称
#  code            :string                                 # 枚举类型的唯一编码
#  additional_info :string                                 # 枚举类型附加信息
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class EnumType < ApplicationRecord
  validates :code, uniqueness: true

  has_many :enum_values
end
