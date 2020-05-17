# == Schema Information
#
# Table name: tf_m_corp
#
#  id                  :integer          not null, primary key
#  region_code         :integer
#  parent_id           :integer
#  code                :string(20)
#  name                :string(40)       not null
#  intro               :string(500)
#  phone               :string(20)
#  address             :string(255)
#  locate_coord        :string(20)
#  order_no            :integer
#  status              :string(1)                              # 0：无效；1：有效：2：删除；
#  agency_code         :string(20)
#  other_desc          :string(255)
#  contact             :string(20)
#  auth_cnt            :integer
#  share_corp_tag      :string(1)
#  first_letter        :string(1)
#  buy_phone           :string(20)
#  sale_phone          :string(20)
#  alliance_cnt        :integer          default(3)
#  alliance_tag        :string(1)        default("0")
#  wdb_tag             :string(1)
#  wdb_id_no           :string(32)
#  sincerity_auth_tag  :string(1)
#  scan_code_time      :integer
#  create_time         :datetime
#  update_time         :datetime
#  auto_assign_tag     :string(1)        default("1")
#  order_amount_rate   :string(10)
#  order_retain_hours  :integer
#  cms_url             :string(255)
#  finance_contacter   :string(20)
#  finance_contact_tel :string(20)
#  disc_num            :integer          default(3)
#  stock_notify_time   :string(20)
#  agent_ids           :string(40)
#  kcb_api_token       :string(64)
#  store_manage_tag    :string(1)
#  stockno_tag         :string(1)
#  push_tag            :string(1)        default("1")
#  dwcgz_notify_time   :string(20)
#  ywcgz_notify_time   :string(20)
#

module Che3bao
  class Corp < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    has_many :staffs
    has_many :stocks
    has_many :channels
    has_many :warranties
    has_many :cooperation_companies
    has_many :mortgage_companies
    has_many :alliances, foreign_key: :own_corp
    has_many :insurance_companies
    has_many :shops
    has_many :customer_levels
    has_many :customers, foreign_key: :owner_corp
    has_many :invalid_reasons
    has_many :defeat_reasons

    has_one :owner, -> { where(boss_tag: 1) }, class_name: "Staff"

    belongs_to :region, foreign_key: :region_code

    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_m_corp"
    # class methods .............................................................
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
