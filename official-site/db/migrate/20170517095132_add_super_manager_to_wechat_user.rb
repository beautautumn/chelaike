# frozen_string_literal: true
class AddSuperManagerToWechatUser < ActiveRecord::Migration[5.0]
  def change
    add_column :wechat_users, :super_manager, :boolean, default: false, comment: "是否是超级管理员"
  end
end
