# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170530155231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advertisements", force: :cascade, comment: "广告" do |t|
    t.string   "ad_type",                 comment: "广告类型"
    t.string   "image_url",               comment: "图片地址"
    t.string   "link",                    comment: "广告链接地址"
    t.integer  "tenant_id",               comment: "所归属租户"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "platform",                comment: "平台类型(移动/桌面)"
    t.index ["tenant_id"], name: "index_advertisements_on_tenant_id", using: :btree
  end

  create_table "car_configurations", force: :cascade, comment: "车辆配置" do |t|
    t.integer  "tenant_id",                                           comment: "所归属租户"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.jsonb    "loan_data",               default: {},   null: false, comment: "贷款配置信息"
    t.bigint   "maintenance_price_cents", default: 1500,              comment: "维保查询价格"
    t.bigint   "insurance_price_cents",   default: 1500,              comment: "用户查询保险记录详情时价格"
    t.index ["tenant_id"], name: "index_car_configurations_on_tenant_id", using: :btree
  end

  create_table "enquiries", force: :cascade, comment: "询价记录" do |t|
    t.integer  "car_id",                      comment: "询价车辆"
    t.string   "name",                        comment: "姓名"
    t.string   "phone",                       comment: "联系电话"
    t.integer  "wechat_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "tenant_id",                   comment: "所属平台租户"
    t.index ["wechat_user_id"], name: "index_enquiries_on_wechat_user_id", using: :btree
  end

  create_table "enum_types", force: :cascade do |t|
    t.string   "name",                         comment: "枚举类型的名称"
    t.string   "code",                         comment: "枚举类型的唯一编码"
    t.string   "additional_info",              comment: "枚举类型附加信息"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "enum_values", force: :cascade do |t|
    t.string   "name",                         comment: "枚举值字面名称"
    t.string   "value",                        comment: "枚举值"
    t.string   "additional_info",              comment: "枚举值附加信息"
    t.integer  "enum_type_id",                 comment: "枚举类型"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "order",                        comment: "枚举排序值"
    t.index ["enum_type_id"], name: "index_enum_values_on_enum_type_id", using: :btree
  end

  create_table "favorite_cars", force: :cascade, comment: "收藏车辆" do |t|
    t.integer  "wechat_user_id"
    t.integer  "car_id",                      comment: "车辆 ID"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "tenant_id",                   comment: "所属平台租户"
    t.index ["car_id"], name: "index_favorite_cars_on_car_id", using: :btree
    t.index ["wechat_user_id"], name: "index_favorite_cars_on_wechat_user_id", using: :btree
  end

  create_table "inspection_reports", force: :cascade, comment: "检测报告" do |t|
    t.string   "source_link",               comment: "检测报告文件地址"
    t.string   "report_type",               comment: "检测报告文件类型"
    t.integer  "car_id",                    comment: "关联车辆"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "external_url",              comment: "外部检测报告网址"
    t.index ["car_id"], name: "index_inspection_reports_on_car_id", using: :btree
  end

  create_table "insurance_records", force: :cascade, comment: "保险理赔记录" do |t|
    t.string   "vin",                                                                         comment: "vin码"
    t.string   "mileage",                                                                     comment: "里程数"
    t.integer  "total_records_count",                                                         comment: "总记录数"
    t.integer  "claims_count",                                                                comment: "事故次数"
    t.jsonb    "record_abstract",                                                             comment: "记录摘要"
    t.jsonb    "claims_abstract",                                                             comment: "出险事故摘要"
    t.decimal  "claims_total_fee_yuan", precision: 12, scale: 2, default: "0.0",              comment: "事故总损失元"
    t.jsonb    "claims_details",                                                              comment: "事故详细记录"
    t.integer  "car_id",                                                                      comment: "报告对应的car_id"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "make",                                                                        comment: "车型信息"
    t.string   "order_id",                                                                    comment: "查询报告ID"
    t.string   "engine_num",                                                                  comment: "发动机号"
    t.string   "license_no",                                                                  comment: "车牌号"
  end

  create_table "maintenance_records", force: :cascade, comment: "维保记录" do |t|
    t.string   "vin",                              comment: "车架号"
    t.string   "car_name",                         comment: "车辆名"
    t.string   "last_date",                        comment: "最后入店日期"
    t.string   "mileage",                          comment: "里程"
    t.string   "new_car_warranty",                 comment: "新车质保"
    t.string   "emission_standard",                comment: "排放标准"
    t.integer  "total_records_count",              comment: "记录条数"
    t.jsonb    "record_abstract",                  comment: "记录摘要"
    t.jsonb    "record_detail",                    comment: "记录详情"
    t.integer  "car_id",                           comment: "关联 car id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["car_id"], name: "index_maintenance_records_on_car_id", using: :btree
  end

  create_table "orders", force: :cascade, comment: "支付订单" do |t|
    t.integer  "order_no",                    comment: "订单号"
    t.integer  "amount_cents",                comment: "订单金额(分)"
    t.string   "channel",                     comment: "支付渠道"
    t.string   "currency",                    comment: "货币类型"
    t.string   "client_ip",                   comment: "客户端IP"
    t.integer  "tenant_id",                   comment: "所属租户"
    t.string   "app_id",                      comment: "Ping++ AppID"
    t.string   "open_id",                     comment: "微信用户 OpenID"
    t.string   "status",                      comment: "订单状态"
    t.string   "subject"
    t.string   "body"
    t.integer  "orderable_id",                comment: "多态"
    t.string   "orderable_type",              comment: "多态"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "product_id"
    t.string   "qr_code_url"
    t.index ["tenant_id"], name: "index_orders_on_tenant_id", using: :btree
  end

  create_table "recommended_cars", force: :cascade, comment: "首页推荐车辆" do |t|
    t.integer  "car_id",                      comment: "车辆id"
    t.integer  "order",                       comment: "排序"
    t.integer  "tenant_id",                   comment: "所归属租户"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "shown_pic_url"
    t.string   "shown_car_name"
    t.index ["tenant_id"], name: "index_recommended_cars_on_tenant_id", using: :btree
  end

  create_table "site_configurations", force: :cascade, comment: "站点配置" do |t|
    t.string   "title",                        comment: "SEO title"
    t.string   "keyword",                      comment: "SEO keyword"
    t.string   "description",                  comment: "SEO description"
    t.integer  "tenant_id",                    comment: "所归属租户"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "icon",                         comment: "网站对应的icon"
    t.string   "icp",                          comment: "网站对应的备案号"
    t.string   "logo",                         comment: "网站对应的logo"
    t.string   "slogan",                       comment: "网站对应的slogan图片"
    t.string   "statistics_code",              comment: "统计代码"
    t.index ["tenant_id"], name: "index_site_configurations_on_tenant_id", using: :btree
  end

  create_table "tenants", force: :cascade, comment: "平台租户，对应每个商家" do |t|
    t.string   "name",                               comment: "商家名"
    t.string   "subdomain",                          comment: "二级子域名"
    t.string   "tld",                                comment: "顶级域名"
    t.string   "app_secret",                         comment: "对应车来客里的app_secret"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "company_id",                         comment: "对应车来客公司"
    t.string   "tenant_type",                        comment: "租户类型： 商家、联盟"
    t.string   "phone",                              comment: "租户的手机，登录用"
    t.integer  "default_wechat_app_id",              comment: "默认微信公众号 ID"
  end

  create_table "transfer_histories", force: :cascade do |t|
    t.integer  "car_id",                     comment: "车辆id"
    t.datetime "transfer_at",                comment: "过户时间"
    t.string   "home_location",              comment: "归属地"
    t.string   "transfer_type",              comment: "过户类型 person business"
    t.string   "description",                comment: "过户描述"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade, comment: "用户" do |t|
    t.string   "username",                     comment: "用户名"
    t.string   "phone",                        comment: "手机号"
    t.string   "password_digest",              comment: "加密密码"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "tenant_id",                    comment: "所属平台租户"
  end

  create_table "wechat_app_user_relations", force: :cascade, comment: "微信用户与公众号关联表" do |t|
    t.integer  "wechat_app_id",               comment: "公众号 ID"
    t.integer  "wechat_user_id",              comment: "用户 ID"
    t.integer  "group_id",                    comment: "分组 ID"
    t.string   "open_id",                     comment: "用户在每个公众号下的 Open ID"
    t.string   "refresh_token",               comment: "refresh_token"
    t.boolean  "subscribed",                  comment: "用户是否关注该应用"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["group_id"], name: "index_wechat_app_user_relations_on_group_id", using: :btree
    t.index ["wechat_app_id"], name: "index_wechat_app_user_relations_on_wechat_app_id", using: :btree
    t.index ["wechat_user_id"], name: "index_wechat_app_user_relations_on_wechat_user_id", using: :btree
  end

  create_table "wechat_apps", force: :cascade, comment: "微信应用" do |t|
    t.string   "app_id",                                                         comment: "微信公众号app id"
    t.integer  "tenant_id",                                                      comment: "租户 id"
    t.string   "user_name",                                                      comment: "微信公众号username"
    t.string   "refresh_token",                                                  comment: "重置令牌的token"
    t.text     "authorities",                                                    comment: "可操作的app权限",              array: true
    t.string   "nick_name",                                                      comment: "授权方昵称"
    t.string   "alias",                                                          comment: "授权方公众号所设置的微信号"
    t.string   "menus_state",                                                    comment: "菜单存储状态"
    t.string   "head_img",          limit: 500
    t.integer  "service_type_info",                                              comment: "公众号类型"
    t.integer  "verify_type_info",                                               comment: "认证类型"
    t.jsonb    "business_info",                                                  comment: "功能的开通状况（0代表未开通，1代表已开通）"
    t.string   "qrcode_url",        limit: 500,                                  comment: " 二维码图片的URL"
    t.string   "state",                         default: "enabled",              comment: "应用状态"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.index ["app_id"], name: "index_wechat_apps_on_app_id", using: :btree
    t.index ["tenant_id"], name: "index_wechat_apps_on_tenant_id", using: :btree
    t.index ["user_name"], name: "index_wechat_apps_on_user_name", using: :btree
  end

  create_table "wechat_messages", force: :cascade, comment: "微信消息" do |t|
    t.string   "key",                                    comment: "事件key"
    t.string   "app_id",                                 comment: "微信公众号 app_id"
    t.string   "message_type",                           comment: "消息类型"
    t.jsonb    "content",      default: {},              comment: "消息内容"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["app_id", "key"], name: "index_wechat_messages_on_app_id_and_key", unique: true, using: :btree
  end

  create_table "wechat_records", force: :cascade, comment: "微信操作记录" do |t|
    t.integer  "wechat_app_user_relation_id"
    t.string   "action",                                                comment: "操作"
    t.jsonb    "data",                        default: {},              comment: "数据记录"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["wechat_app_user_relation_id"], name: "index_wechat_records_on_wechat_app_user_relation_id", using: :btree
  end

  create_table "wechat_users", force: :cascade, comment: "微信用户" do |t|
    t.string   "nick_name",                                  comment: "微信昵称"
    t.string   "gender",                                     comment: "用户性别"
    t.string   "city",                                       comment: "所在城市"
    t.string   "province",                                   comment: "所在省份"
    t.string   "country",                                    comment: "所在国家"
    t.string   "avatar",                                     comment: "头像"
    t.string   "note",                                       comment: "备注"
    t.string   "union_id",                                   comment: "Union ID"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "phone",                                      comment: "微信用户手机号"
    t.boolean  "super_manager", default: false,              comment: "是否是超级管理员"
  end

  add_foreign_key "advertisements", "tenants"
  add_foreign_key "car_configurations", "tenants"
  add_foreign_key "enum_values", "enum_types"
  add_foreign_key "orders", "tenants"
  add_foreign_key "recommended_cars", "tenants"
  add_foreign_key "site_configurations", "tenants"
end
