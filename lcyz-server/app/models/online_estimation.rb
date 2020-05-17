# == Schema Information
#
# Table name: online_estimations # 在线评估
#
#  id             :integer          not null, primary key # 在线评估
#  brand_name     :string                                 # 品牌
#  series_name    :string                                 # 车系
#  style_name     :string                                 # 车型
#  licensed_at    :string                                 # 上牌日期
#  mileage        :float                                  # 表显里程(万公里)
#  customer_phone :string                                 # 手机号码
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class OnlineEstimation < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def transfer_to_acquisition_info(company)
    AcquisitionCarInfo.create!(
      company: company,
      brand_name: brand_name,
      series_name: series_name,
      style_name: style_name,
      licensed_at: licensed_at,
      mileage: mileage,
      owner_info: { phone: customer_phone }
    )
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
