# == Schema Information
#
# Table name: alliance_invitations
#
#  id                  :integer          not null, primary key
#  alliance_id         :integer                                # 联盟ID
#  company_id          :integer                                # 公司ID
#  state               :string           default("pending")    # 联盟邀请状态
#  assignee_id         :integer                                # 处理人
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  operation_record_id :integer                                # 联盟邀请操作记录
#

class AllianceInvitation < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  include AASM
  # relationships .............................................................
  belongs_to :alliance
  belongs_to :assignee, class_name: "User", foreign_key: :assignee_id
  belongs_to :operation_record
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  aasm column: "state" do
    # 未处理
    state :pending, initial: true
    # 已接受
    state :accepted
    # 已拒绝
    state :refused

    # 同意加入联盟
    event :accept, after: proc { |user_id| join_alliance && assign(user_id) } do
      transitions from: :pending, to: :accepted
    end

    # 拒绝加入联盟
    event :reject, after: proc { |user_id| assign(user_id) } do
      transitions from: :pending, to: :accepted
    end
  end
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def join_alliance
    alliance.add_company(Company.find(company_id))
  end

  def assign(user_id)
    self.assignee_id = user_id
    save!
  end
end
