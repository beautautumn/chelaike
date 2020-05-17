# == Schema Information
#
# Table name: easy_loan_rating_statements # 车融易评级说明
#
#  id         :integer          not null, primary key # 车融易评级说明
#  score      :integer                                # 分数
#  rate_type  :string                                 # 评级类型
#  content    :text                                   # 评级说明内容
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::RatingStatement, type: :model do
end
