module Dashboard
  class CompaniesController < ApplicationController

    include ApplicationHelper

    before_action :find_company, only: [:edit_token, :add_label]
    before_action :find_company_property, only: [:edit_advisor, :add_label]
    before_action do
      authorize :dashboard_company
    end

    def index
      @q = Company.includes(:owner).order(id: :desc)

      if params.key?(:active_tag) && !params[:active_tag].empty?
        @q = @q.where(active_tag: (params[:active_tag]=="1")? true : false)
      end

      staff_id = params[:staff_id]
      if staff_id && !staff_id.empty?
        company_ids = CompanyProperty.where(staff_id: staff_id).collect{|r| r.company_id}
        @q = @q.where("companies.id IN (?)", company_ids).order(id: :desc)
      end

      company_id = params[:company_id]
      if company_id && !company_id.empty?
        @q = @q.where(id: company_id)
      end

      if params.key?(:manage_active_tag) && !params[:manage_active_tag].empty?
        company_ids = CompanyProperty.where(active_tag: (params[:manage_active_tag]=="1")? true : false)
                          .collect{|r| r.company_id}
        @q = @q.where("companies.id IN (?)", company_ids)
      end

      if params.key?(:label) && !params[:label].empty?
        sql = <<-SQL
            EXISTS (
              SELECT *
                FROM unnest(dashboard_company_properties.labels) l(label)
                WHERE
                  label->>'label' LIKE :label
            )
        SQL
        company_ids = CompanyProperty.where(sql.squish!, label: "%" + params[:label] + "%").collect{|r| r.company_id}
        @q = @q.where("companies.id IN (?)", company_ids)
      end

      @q = @q.ransack(params[:q])
      @companies = @q.result
                     .page(params[:page])
                     .per(20)
      @counter = @q.result.count

      store_location
    end

    def destroy
      Company.transaction do
        company = Company.find(params[:id])
        record_destroy(company)
        company.destroy!
      end

      redirect_back_or companies_path, status: 303
    end

    def edit_token
      @oper_type = params[:oper_type]
    end

    def update_token
      company_id = params[:id]
      oper_type = params[:oper_type]
      oper_type_name = (oper_type == "add" ? "赠送" : "扣除")
      amount = params[:amount].to_f
      success = false

      ActiveRecord::Base.connection.transaction do
        company = Company.find(company_id)
        token = Token.find_or_create_by(company_id: company_id)

        if oper_type == 'add'
          value = token.balance.to_f + amount.to_f
        else
          value = token.balance.to_f - amount.to_f
        end

        if (amount>0.0) && (value >= 0.0)
          record_update_token(company, token.balance, value)

          token.with_lock do
            token.balance = value
            token.save!
          end
          success = true
        end
      end

      if success
        flash[:success] = "车币#{oper_type_name}成功！"
        redirect_back_or companies_path
      else
        flash[:danger] = "车币数额有误！"
        redirect_back_or edit_token_company_path(company_id, oper_type: oper_type)
      end
    end

    def edit_advisor
    end

    def update_advisor
      company_id = params[:id]
      new_staff_id = params[:company_property][:staff_id]
      ActiveRecord::Base.connection.transaction do
        company = Company.find(company_id)
        property = CompanyProperty.find_by(company_id: company_id) ||
                   CompanyProperty.new(company_id: company_id)
        if (company)
          begin
            old_staff = Staff.find(property.staff_id)
          rescue
            old_staff = nil
          end
          begin
            new_staff = Staff.find(new_staff_id)
          rescue
            new_staff = nil
          end
          record_update_advisor(company, old_staff, new_staff)

          property.staff_id = new_staff_id
          property.save
        end
      end
      redirect_back_or companies_path, status: 303
    end

    def reset_boss
      company_id = params[:id]
      user_id = params[:user_id]
      user = User.find(user_id)
      ActiveRecord::Base.connection.transaction do
        company = Company.find(company_id)
        if user && (user.company.id == company.id)
          begin
            record_reset_boss(company, user)

            Operation::Authority.become_to_boss(user)
            flash[:success] = "车商【#{user.company.name}】的老板【#{user.name}】权限恢复成功！"
            redirect_back_or companies_path
          rescue => e
            flash[:danger] = "系统异常：#{e}"
            redirect_back_or companies_path
          end
        else
          flash[:danger] = "车商老板user_id错误！"
          redirect_back_or companies_path
        end
      end
    end

    def active_tag
      company_id = params[:company_id]
      tag_value = (params[:active]=="true")
      toggle_company_tag(company_id, :active_tag, tag_value)
      redirect_back_or companies_path, status: 303
    end

    def honesty_tag
      company_id = params[:company_id]
      tag_value = (params[:active]=="true")
      toggle_company_tag(company_id, :honesty_tag, tag_value)
      redirect_back_or companies_path, status: 303
    end

    def own_brand_tag
      company_id = params[:company_id]
      tag_value = (params[:active]=="true")
      toggle_company_tag(company_id, :own_brand_tag, tag_value)
      redirect_back_or companies_path, status: 303
    end

    def clear_tag
      tag_type = params[:type]
      ActiveRecord::Base.connection.transaction do
        case tag_type
          when "active_tag"
            Company.update_all(active_tag: false)
            record_clear_tag(:active_tag)
          when "honesty_tag"
            Company.update_all(honesty_tag: false)
            record_clear_tag(:honesty_tag)
          else
            Company.update_all(own_brand_tag: false)
            record_clear_tag(:own_brand_tag)
        end
      end
      redirect_back_or companies_path, status: 303
    end

    def manage_active_tag
      company_id = params[:company_id]
      tag_value = (params[:active]=="true")
      ActiveRecord::Base.connection.transaction do
        company = Company.find(company_id)
        property = CompanyProperty.find_by(company_id:  company_id) ||
                        CompanyProperty.new(company_id: company_id)
        if (company)
          record_toggle_manage_tag(company, :active_tag, tag_value)

          property.active_tag = tag_value
          property.save
        end
      end
      redirect_back_or companies_path, status: 303
    end

    def clear_manage_tag
      redirect_back_or companies_path, status: 303
    end

    def add_label
    end

    def update_label
      company_id = params[:id]
      label = params[:label]
      oper_type = params[:oper_type]
      ActiveRecord::Base.connection.transaction do
        company = Company.find(company_id)
        property = CompanyProperty.find_by(company_id:  company_id) ||
                        CompanyProperty.new(company_id: company_id)

        if (company)
          if (oper_type == "add")
            record_update_label(company, :add_label, label)

            property.labels << {label: label}
            property.labels.uniq!
            property.save
          elsif (oper_type == "delete")
            record_update_label(company, :delete_label, label)

            property.labels.delete_if{|l| l["label"]==label}
            property.save
          end
        end
      end
      redirect_back_or companies_path, status: 303
    end


    private

      def find_company
        @company = Company.find(params[:id])
      end

      def find_company_property
        @company_property = CompanyProperty.find_by(company_id: params[:id]) ||
                        CompanyProperty.new(company_id: params[:id])
      end

      def toggle_company_tag(company_id, tag_type, tag_value)
        ActiveRecord::Base.connection.transaction do
          company = Company.find(company_id)
          if (company)
            record_toggle_tag(company, tag_type, tag_value)

            company.update(tag_type => tag_value)
          end
        end
      end

      def record_destroy(company)
        current_staff.operation_records.create!(
          operation_type: "company_deletion",
          content: {
            company_id: company.id,
            company_name: company.name,
            owner_id: company.owner_id,
            owner_name: company.owner.try(:name)
          }
        )
      end

      def record_update_token(company, old_value, new_value)
        current_staff.operation_records.create!(
          operation_type: "company_update_token",
          content: {
            company_id: company.id,
            company_name: company.name,
            old_value: old_value,
            new_value: new_value
          }
        )
      end

      def record_update_advisor(company, old_staff, new_staff)
        old_staff = Staff.new if old_staff.nil?
        new_staff = Staff.new if new_staff.nil?
        current_staff.operation_records.create!(
          operation_type: "company_update_advisor",
          content: {
            company_id: company.id,
            company_name: company.name,
            old_value: old_staff,
            new_value: new_staff
          }
        )
      end

      def record_toggle_tag(company, tag_type, enabled)
        action_type = enabled ? "enable_company_#{tag_type}" : "disable_company_#{tag_type}"

        current_staff.operation_records.create(
          operation_type: action_type,
          content: {
            company_id: company.id,
            company_name: company.name
          }
        )
      end

      def record_clear_tag(tag_type)
        current_staff.operation_records.create(
          operation_type: "companies_clear_#{tag_type}"
        )
      end

      def record_toggle_manage_tag(company, tag_type, enabled)
        action_type = enabled ? "enable_manage_#{tag_type}" : "disable_manage_#{tag_type}"

        current_staff.operation_records.create(
          operation_type: action_type,
          content: {
            company_id: company.id,
            company_name: company.name
          }
        )
      end

      def record_update_label(company, oper_type, label)
        current_staff.operation_records.create(
          operation_type: "company_#{oper_type}",
          content: {
            company_id: company.id,
            company_name: company.name,
            value: label
          }
        )
      end

      def record_reset_boss(company, user)
        current_staff.operation_records.create(
          operation_type: "reset_boss_authority",
          content: {
            company_id: company.id,
            company_name: company.name,
            user_id: user.id,
            user_name: user.username,
            phone: user.phone,
            name: user.name
          }
        )
      end

  end
end
