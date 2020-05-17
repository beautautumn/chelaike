class SmsService
  attr_accessor :user

  def initialize(phone_number, action = nil)
    @user = EasyLoan::User.find_by_phone(phone_number)
    raise ActiveRecord::RecordNotFound, "#{phone_number} 号码不存在" unless @user
    raise EasyLoan::User::TokenExpired, "60秒内只能发送一次" unless can?(@user.expired_at, action)
  end

  def code
    @_code ||= (0...6).map { (0..9).to_a[rand(10)] }.join
  end

  def send_cms
    @user.update!(
      token: code,
      expired_at: Time.zone.now + 10.minutes
    )
    Yunpian.signature = "【车融易】"
    Yunpian.send_to!(
      @user.phone,
      I18n.t("yunpian.easy_loan", code: code)
    )
  end

  private

  def can?(time, action)
    return true if action == "verify"
    time ? Time.zone.now - (time - 10.minutes) > 60 : true
  end
end
