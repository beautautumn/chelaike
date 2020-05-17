# == Schema Information
#
# Table name: users # 用户
#
#  id                         :integer          not null, primary key    # 用户
#  name                       :string           not null                 # 姓名
#  username                   :string                                    # 用户名
#  password_digest            :string           not null                 # 加密密码
#  email                      :string                                    # 邮箱
#  pass_reset_token           :string                                    # 重置密码token
#  phone                      :string                                    # 手机号码
#  state                      :string           default("enabled")       # 状态
#  is_alliance_contact        :boolean          default(FALSE)           # 是否联盟联系人
#  pass_reset_expired_at      :datetime                                  # 重置密码token过期时间
#  last_sign_in_at            :datetime                                  # 最后登录时间
#  current_sign_in_at         :datetime                                  # 当前登录时间
#  company_id                 :integer                                   # 所属公司
#  shop_id                    :integer                                   # 所属分店
#  manager_id                 :integer                                   # 所属经理
#  note                       :text                                      # 员工描述
#  authority_type             :string           default("role")          # 权限选择类型
#  authorities                :text             default([]), is an Array # 权限
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  deleted_at                 :datetime                                  # 删除时间
#  avatar                     :string                                    # 头像URL
#  settings                   :jsonb                                     # 设置
#  mac_address                :string                                    # MAC地址
#  cross_shop_authorities     :text             default([]), is an Array # 跨店权限
#  device_numbers             :text             default([]), is an Array # App设备号
#  client_info                :jsonb                                     # 客户端信息
#  first_letter               :string                                    # 拼音
#  mobile_app_car_detail_menu :string           is an Array              # 移动APP车辆详情页菜单
#  rc_token                   :string                                    # 融云token
#

class SystemMessageUser < User
  MESSAGE_STATISTICS_ID = "statistics_messager".freeze
  MESSAGE_STOCK_ID = "stock_messager".freeze
  MESSAGE_CUSTOMER_ID = "customer_messager".freeze
  MESSAGE_SYSTEM_ID = "system_messager".freeze
  MESSAGE_LOAN_ID = "loan_messager".freeze

  MESSAGERS = %W(#{MESSAGE_STATISTICS_ID} #{MESSAGE_STOCK_ID}
                 #{MESSAGE_CUSTOMER_ID} #{MESSAGE_SYSTEM_ID}
                 #{MESSAGE_LOAN_ID}).freeze

  MESSAGER_ID_MAP = {
    "statistics_messager" => -100,
    "stock_messager" => -200,
    "customer_messager" => -300,
    "system_messager" => -400,
    "loan_messager" => -500
  }.freeze

  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # after_update :refresh_rc_token
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  class << self
    MESSAGERS.each do |messager|
      define_method "#{messager}_user" do
        user = User.find(MESSAGER_ID_MAP.fetch(messager, -400))
        return user if user.rc_token.present?

        update_rc_token!(user)
        user
      end
    end

    def update_rc_token!(user)
      rc_user = Rongcloud::User.new(
        id: user.id,
        name: user.name,
        portrait_uri: user.avatar
      )

      token = rc_user.token
      user.update!(rc_token: token)
    end

    def get_messager(message_type)
      send("#{message_type}_messager_user")
    end
  end
  # public instance methods ...................................................

  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def refresh_rc_token
    rc_user = Rongcloud::User.new(
      id: id,
      name: name,
      portrait_uri: avatar
    )

    rc_user.refresh(name: name, portrait_uri: avatar)
  end
end
