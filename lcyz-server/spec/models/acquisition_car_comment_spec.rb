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

require "rails_helper"

RSpec.describe AcquisitionCarComment, type: :model do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  describe "#set_company" do
    it "设置回复的公司" do
      comment = AcquisitionCarComment.create(commenter_id: zhangsan.id)
      expect(comment.company).to eq zhangsan.company
    end
  end
end
