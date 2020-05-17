class CreateAllianceUsers < ActiveRecord::Migration
  def change
    create_table :alliance_users, comment: "联盟公司的用户" do |t|
      t.string   "name",                                       null: false,              comment: "姓名"
      t.string   "username",                                                             comment: "用户名"
      t.string   "password_digest",                            null: false,              comment: "加密密码"
      t.string   "email",                                                                comment: "邮箱"
      t.string   "pass_reset_token",                                                     comment: "重置密码token"
      t.string   "phone",                                                                comment: "手机号码"
      t.string   "state",                  default: "enabled",                           comment: "状态"
      t.datetime "pass_reset_expired_at",                                                comment: "重置密码token过期时间"
      t.datetime "last_sign_in_at",                                                      comment: "最后登录时间"
      t.datetime "current_sign_in_at",                                                   comment: "当前登录时间"
      t.integer  "company_id",                                                           comment: "所属公司"
      t.integer  "manager_id",                                                           comment: "所属经理"
      t.text     "note",                                                                 comment: "员工描述"
      t.string   "authority_type",         default: "role",                              comment: "权限选择类型"
      t.text     "authorities",            default: [],                     array: true, comment: "权限"
      t.datetime "created_at",                                 null: false
      t.datetime "updated_at",                                 null: false
      t.datetime "deleted_at",                                                           comment: "删除时间"
      t.string   "avatar",                                                               comment: "头像URL"
      t.jsonb    "settings",               default: {},                                  comment: "设置"
      t.string   "first_letter",                                                         comment: "拼音"

      t.timestamps null: false
    end
  end
end
