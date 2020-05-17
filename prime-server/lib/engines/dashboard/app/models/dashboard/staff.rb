# == Schema Information
#
# Table name: dashboard_staffs # 员工表
#
#  id         :integer          not null, primary key # 员工表
#  phone      :string                                 # 员工手机号
#  name       :string                                 # 员工姓名
#  state      :string           default("enabled")    # 员工状态
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  manager_id :integer                                # 所属主管ID
#  role       :string                                 # 角色
#

module Dashboard
  class Staff < ActiveRecord::Base
    ROLES = {
      admin: "管理员",
      consultant: "服务顾问",
      customer_service: "客服",
      developer: "开发人员",
      financial: "财务人员"
    }.freeze

    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    # relationships .............................................................
    has_many :operation_records
    has_many :company_staff_relationships
    has_many :companies, through: :company_staff_relationships, source: :company
    belongs_to :manager, class_name: "Staff", foreign_key: :manager_id
    # validations ...............................................................
    validates :phone, uniqueness: true, presence: true
    # callbacks .................................................................
    # scopes ....................................................................
    scope :consultants, lambda {
      where(role: %w(服务顾问 管理员))
    }
    # additional config .........................................................
    # class methods .............................................................
    # public instance methods ...................................................
    ROLES.each do |label, name|
      define_method "#{label}?" do
        role == name
      end
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
