# == Schema Information
#
# Table name: easy_loan_authority_roles # 车融易角色权限
#
#  id                      :integer          not null, primary key    # 车融易角色权限
#  name                    :string                                    # 权限名称
#  note                    :text                                      # 权限说明
#  authorities             :text             default([]), is an Array # 权限清单
#  easy_loan_sp_company_id :integer                                   # 和sp公司关联
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class EasyLoan::AuthorityRolesController < EasyLoan::ApplicationController
  before_action :set_authority_role, only: [:update]
  def index
    render json: EasyLoan::AuthorityRole.all,
           each_serializer: EasyLoanSerializer::AuthorityRoleSerializer::Common,
           root: "data"
  end

  def create
    param! :authority_role, Hash do |a|
      a.param! :authorities, Array
    end

    EasyLoan::AuthorityRole.create!(authority_roles_params)
    render json: { data: "success" }, status: 200, scope: nil
  end

  def update
    param! :authority_role, Hash do |a|
      a.param! :authorities, Array
    end

    @authority_role.update_attributes!(authority_roles_params)
    render json: @authority_role,
           each_serializer: EasyLoanSerializer::AuthorityRoleSerializer::Common,
           root: "data"
  end

  private

  def set_authority_role
    @authority_role = EasyLoan::AuthorityRole.find_by_id!(params[:id])
  end

  def authority_roles_params
    params.require(:authority_role).permit(:name, :note, authorities: [])
  end
end
