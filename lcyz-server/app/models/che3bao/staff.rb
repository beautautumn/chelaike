# == Schema Information
#
# Table name: tf_m_staff
#
#  id                 :integer          not null, primary key
#  login_name         :string(40)       not null
#  password           :string(40)       not null
#  name               :string(20)
#  sex                :integer                                # 0-女性；1-男；2-未知；
#  tel                :string(40)       not null
#  qq_number          :string(30)
#  remark             :string(500)
#  last_login_time    :datetime
#  status             :string(1)        not null              # 0无效；1：有效
#  email              :string(40)
#  msg_tag            :string(1)
#  mac_tag            :string(1)
#  create_time        :datetime
#  corp_id            :integer
#  wx_openid          :string(255)
#  try_account_tag    :string(1)
#  mac_address        :string(2000)
#  locate_id          :integer
#  boss_tag           :string(1)
#  alliance_tag       :string(1)
#  wx_user_id         :integer
#  alliance_role      :string(255)
#  innercar_push_tag  :string(1)
#  khb_device_id      :string(64)
#  skill_type         :string(1)
#  parent_id          :integer
#  disc_push_tag      :string(1)
#  allian_push_tag    :string(1)
#  cust_info_push_tag :string(1)
#  cust_sub_push_tag  :string(1)
#

module Che3bao
  class Staff < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    include Appropriatable
    # relationships .............................................................
    belongs_to :corp
    belongs_to :parent, foreign_key: :parent_id, class_name: Staff.name

    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_m_staff"
    # class methods .............................................................
    # public instance methods ...................................................
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
