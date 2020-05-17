# == Schema Information
#
# Table name: acquisition_car_comments # 收车信息的回复
#
#  id                      :integer          not null, primary key # 收车信息的回复
#  commenter_id            :integer                                # 信息回复者的ID
#  company_id              :integer                                # 回复者所在公司
#  acquisition_car_info_id :integer                                # 所属的收车信息
#  valuation_cents         :integer                                # 回复人的估价
#  cooperate               :boolean                                # 合作收车
#  is_seller               :boolean                                # 是否成为销售方
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  note_text               :text                                   # 文字备注
#  note_audios             :jsonb            is an Array           # 多条语音备注
#

class AcquisitionCarComment < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  include Priceable
  # relationships .............................................................
  belongs_to :acquisition_car_info
  belongs_to :commenter, class_name: "User"
  belongs_to :company
  # validations ...............................................................
  validates :commenter_id, presence: true
  # callbacks .................................................................
  before_save :set_company
  # scopes ....................................................................
  # additional config .........................................................
  price_wan :valuation
  priceable :valuation, unit: :wan, monetize_options: { allow_nil: true }
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def set_company
    self.company_id = commenter.company.id
  end
end
