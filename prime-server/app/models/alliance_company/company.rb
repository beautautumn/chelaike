# == Schema Information
#
# Table name: alliance_companies # 联盟公司
#
#  id                  :integer          not null, primary key # 联盟公司
#  name                :string                                 # 名称
#  contact             :string                                 # 联系人
#  contact_mobile      :string                                 # 联系人电话
#  sale_mobile         :string                                 # 销售电话
#  logo                :string                                 # LOGO
#  note                :string                                 # 备注
#  province            :string                                 # 省份
#  city                :string                                 # 城市
#  district            :string                                 # 区
#  street              :string                                 # 详细地址
#  owner_id            :integer                                # 公司拥有者ID
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  settings            :jsonb                                  # 设置
#  deleted_at          :datetime                               # 删除时间
#  slogan              :text                                   # 宣传语
#  qrcode              :string                                 # 商家二维码
#  banners             :string           is an Array           # 网站Banners
#  alliances_count     :integer                                # 联盟数量
#  water_mark_position :jsonb                                  # 水印位置
#  water_mark          :string                                 # 水印图片url
#

class AllianceCompany::Company < ActiveRecord::Base
  belongs_to :owner, foreign_key: :owner_id,
                     class_name: "AllianceCompany::User"

  has_many :authority_roles, dependent: :destroy,
                             class_name: "AllianceCompany::AuthorityRole",
                             foreign_key: :alliance_company_id

  has_many :channels, class_name: "::Channel", dependent: :destroy, as: :company

  has_many :users, class_name: "AllianceCompany::User"
  has_many :companies, class_name: "::Company",
                       foreign_key: :alliance_company_id

  has_one :alliance, foreign_key: :alliance_company_id
  # 联盟公司在公司表中对应的记录
  has_one :company, through: :alliance, source: :owner
  has_one :wechat_app, as: :company, dependent: :destroy

  has_many :customers, dependent: :destroy, foreign_key: :alliance_company_id
  has_many :intentions, class_name: "::Intention", foreign_key: :alliance_company_id
  has_many :intention_levels, class_name: "::IntentionLevel", as: :company

  delegate :cars, to: :alliance
  delegate :nickname, to: :alliance_company_relationship

  def add_companies(companies)
    Company.where(id: companies).update_all(
      alliance_company_id: id
    )
  end

  def add_company(company)
    company.update(alliance_company_id: id)
  end
end
