# == Schema Information
#
# Table name: easy_loan_users # 车融易用户模型
#
#  id                          :integer          not null, primary key    # 车融易用户模型
#  phone                       :string                                    # 手机号码
#  token                       :string                                    # 验证码
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  expired_at                  :datetime                                  # 短信验证码失效时间
#  current_device_number       :string                                    # 车融易当前登录设备号码
#  name                        :string                                    # 车融易用户姓名
#  easy_loan_sp_company_id     :integer                                   # 所属sp公司
#  authorities                 :text             default([]), is an Array # 权限清单
#  city                        :text                                      # 员工所属地区
#  status                      :boolean          default(TRUE)            # 员工状态
#  easy_loan_authority_role_id :integer                                   # 角色关联
#  rc_token                    :string                                    # 融云token
#

class EasyLoan::UsersController < EasyLoan::ApplicationController
  before_action :set_user, only: [:update]

  def me
    render json: @current_user,
           each_serializer: EasyLoanSerializer::UserSerializer::Basic,
           root: "data"
  end

  def index
    basic_params_validations

    users = paginate(EasyLoan::User.sp_company_users(@current_user.easy_loan_sp_company_id))
    render json: users,
           each_serializer: EasyLoanSerializer::UserSerializer::Basic,
           root: "data"
  end

  def create
    EasyLoan::User.create!(user_params.merge(easy_loan_sp_company_id: @current_user.sp_company.id))
    render json: { data: "success" }, status: 200, scope: nil
  end

  def update
    param! :user, Hash do |u|
      u.param! :status, :boolean, default: true
    end
    role = EasyLoan::AuthorityRole.where(id: params[:user][:easy_loan_authority_role_id]).first
    authorities = role.present? ? role.authorities : (params[:user][:authorities]).try(:uniq)
    params[:user][:authorities] = authorities
    @user.update(user_params)
    render json: @user,
           each_serializer: EasyLoanSerializer::UserSerializer::Basic,
           root: "data"
  end

  def rc_token
    service = ChatService::User.new(current_user, :easy_loan)
    service.rc_token

    render json: current_user,
           serializer: EasyLoanSerializer::UserSerializer::Basic,
           root: "data"
  end

  private

  def set_user
    @user = EasyLoan::User.find_by_id!(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :phone, :name, :status, :city,
      :easy_loan_authority_role_id, authorities: [])
  end
end
