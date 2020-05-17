# == Schema Information
#
# Table name: detection_configs # 检测报告平台配置
#
#  id            :integer          not null, primary key # 检测报告平台配置
#  platform_name :string                                 # 平台名
#  key           :string                                 # 平台key
#  c_id          :integer                                # 对应商家id
#  c_code        :string                                 # 商家code
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DetectionConfig < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  before_create :hash_code

  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def hash_code
    self.key = SecureRandom.hex(10)
    self.c_code = SecureRandom.hex(10)
  end
end
