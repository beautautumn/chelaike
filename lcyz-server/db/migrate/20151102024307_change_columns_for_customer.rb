class ChangeColumnsForCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :mobile
    remove_column :customers, :province
    remove_column :customers, :city
    add_column :customers, :phone, :string, comment: "客户主要联系电话"
    add_column :customers, :phones, :string, array: true, default: [], comment: "客户联系电话"
    add_column :customers, :gender, :string, comment: "性别"
    add_column :customers, :id_number, :string, comment: "证件号"
    add_column :customers, :avatar, :string, comment: "客户头像"
    add_column :customers, :user_id, :integer, index: true, comment: "客户所属员工ID"
    add_column :customers, :first_letter, :string, index: true, comment: "客户姓名首字母"
  end
end
