# == Schema Information
#
# Table name: easy_loan_sp_companies # 借款的sp公司
#
#  id         :integer          not null, primary key # 借款的sp公司
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::SpCompany, type: :model do
end
