# == Schema Information
#
# Table name: tf_m_customer
#
#  cust_id             :integer          not null, primary key
#  wx_user_id          :integer
#  owner_staff         :integer
#  owner_corp          :integer
#  level_code          :integer
#  infosource_code     :integer
#  region_code         :integer
#  create_staff        :integer
#  region_name         :string(40)
#  sex_name            :string(10)
#  cust_name           :string(40)
#  phone_number        :string(40)
#  cust_follow_state   :string(10)
#  curr_intend_type    :string(2)
#  curr_salesource_id  :integer
#  curr_acqusource_id  :integer
#  follow_his_id       :integer
#  last_follow_his     :integer
#  create_method       :string(1)
#  update_time         :datetime
#  create_time         :datetime
#  valid_tag           :string(1)
#  chat_tag            :string(1)
#  staff_tag           :string(1)        default("0")
#  id_no               :string(32)
#  birth_date          :string(10)
#  contact_addr        :string(255)
#  professional        :string(255)
#  hobby               :string(255)
#  check_valid_month   :string(10)
#  issur_valid_date    :string(10)
#  mortgage_date       :string(10)
#  intro_person        :integer
#  alloc_time          :datetime
#  owner_store         :integer
#  cust_remark         :string(500)
#  cur_visit_id        :integer
#  driver_license_type :string(10)
#  driver_license_date :date
#  cust_create_date    :date
#  maintain_staff      :integer
#

module Che3bao
  class Customer < ActiveRecord::Base
    # accessors .................................................................
    # extends ...................................................................
    # includes ..................................................................
    include Che3baoConnection
    # relationships .............................................................
    belongs_to :corp, foreign_key: :owner_corp
    belongs_to :staff, foreign_key: :owner_staff
    belongs_to :customer_level, foreign_key: :level_code
    belongs_to :channel, foreign_key: :infosource_code
    belongs_to :region, foreign_key: :region_code

    belongs_to :sale_intention, foreign_key: :curr_salesource_id # 求购
    belongs_to :acquisition_intention, foreign_key: :curr_acqusource_id # 卖车

    belongs_to :intention_push_history, foreign_key: :follow_his_id
    belongs_to :last_intention_push_history,
               foreign_key: :last_follow_his,
               class_name: Che3bao::IntentionPushHistory.name
    belongs_to :creator, foreign_key: :create_staff, class_name: Che3bao::Staff.name

    has_many :intention_push_histories, foreign_key: :cust_id
    # belongs_to :
    # validations ...............................................................
    # callbacks .................................................................
    # scopes ....................................................................
    # additional config .........................................................
    self.table_name = "tf_m_customer"
    self.primary_key = "cust_id"
    # class methods .............................................................
    # public instance methods ...................................................
    def note
      [
        ["生日", birth_date],
        ["联系地址", contact_addr],
        ["职业", professional],
        ["爱好", hobby],
        ["年审到期日", check_valid_month],
        ["交强险到期日", issur_valid_date],
        ["驾照类型", driver_license_type],
        ["驾照注册日期", driver_license_date]
      ].select { |_, value| value.present? }
       .map { |arr| arr.join(": ") }
       .join("\n\r")
    end

    def intention_type
      curr_intend_type.to_i == 1 ? "sale" : "seek"
    end

    def sex
      case sex_name
      when "0"
        "male"
      when "1"
        "male"
      when "2"
        "female"
      when "-1"
        "male"
      when "男"
        "male"
      when "女"
        "female"
      end
    end

    def state
      case cust_follow_state
      when "dgj"
        "pending"
      when "yyy"
        "interviewed"
      when "ycj"
        "completed"
      when "gjz"
        "processing"
      when "ysk"
        "invalid"
      when "yzb"
        "failed"
      else
        "pending"
      end
    end
    # protected instance methods ................................................
    # private instance methods ..................................................
  end
end
