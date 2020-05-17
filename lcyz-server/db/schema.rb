# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20171221074717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accredited_records", force: :cascade, comment: "授信记录" do |t|
    t.integer  "company_id",                                 comment: "被授信公司"
    t.integer  "limit_amount_cents",  limit: 8,              comment: "额度"
    t.integer  "funder_company_id",                          comment: "资金方公司"
    t.integer  "in_use_amount_cents",                        comment: "已用额度"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "acquisition_car_comments", force: :cascade, comment: "收车信息的回复" do |t|
    t.integer  "commenter_id",                                                             comment: "信息回复者的ID"
    t.integer  "company_id",                                                               comment: "回复者所在公司"
    t.integer  "acquisition_car_info_id",                                                  comment: "所属的收车信息"
    t.integer  "valuation_cents",         limit: 8,                                        comment: "回复人的估价"
    t.boolean  "cooperate",                                                                comment: "合作收车"
    t.boolean  "is_seller",                                                                comment: "是否成为销售方"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.text     "note_text",                                                                comment: "文字备注"
    t.jsonb    "note_audios",                       default: [],              array: true, comment: "多条语音备注"
  end

  add_index "acquisition_car_comments", ["acquisition_car_info_id"], name: "index_acquisition_car_comments_on_acquisition_car_info_id", using: :btree
  add_index "acquisition_car_comments", ["commenter_id"], name: "index_acquisition_car_comments_on_commenter_id", using: :btree
  add_index "acquisition_car_comments", ["company_id"], name: "index_acquisition_car_comments_on_company_id", using: :btree

  create_table "acquisition_car_infos", force: :cascade, comment: "收车信息" do |t|
    t.string   "brand_name",                                                                     comment: "品牌名称"
    t.string   "series_name",                                                                    comment: "车系名称"
    t.string   "style_name",                                                                     comment: "车型名称"
    t.integer  "acquirer_id",                                                                    comment: "发布收车信息的人ID"
    t.date     "licensed_at",                                                                    comment: "licensed_at"
    t.integer  "new_car_guide_price_cents",  limit: 8,                                           comment: "新车指导价"
    t.integer  "new_car_final_price_cents",  limit: 8,                                           comment: "新车完税价"
    t.date     "manufactured_at",                                                                comment: "出厂日期"
    t.float    "mileage",                                                                        comment: "表显里程(万公里)"
    t.string   "exterior_color",                                                                 comment: "外饰颜色"
    t.string   "interior_color",                                                                 comment: "内饰颜色"
    t.float    "displacement",                                                                   comment: "排气量"
    t.integer  "prepare_estimated_cents",    limit: 8,                                           comment: "整备预算"
    t.hstore   "manufacturer_configuration",                                                     comment: "车辆配置"
    t.integer  "valuation_cents",            limit: 8,                                           comment: "收车人估价"
    t.string   "state",                                                                          comment: "收车信息状态"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "note_text",                                                                      comment: "文字备注"
    t.integer  "key_count",                                                                      comment: "车辆钥匙数"
    t.jsonb    "images",                               default: [],                 array: true, comment: "多张图片信息"
    t.jsonb    "owner_info",                                                                     comment: "原车主信息"
    t.boolean  "is_turbo_charger",                     default: false,                           comment: "是否自然排气"
    t.jsonb    "note_audios",                          default: [],                 array: true, comment: "多条语音备注"
    t.string   "configuration_note",                                                             comment: "配置说明"
    t.jsonb    "procedure_items",                                                                comment: "手续信息"
    t.string   "license_info",                                                                   comment: "牌证信息"
    t.integer  "company_id",                                                                     comment: "发布者所属公司"
    t.string   "intention_level_name",                                                           comment: "客户等级"
    t.integer  "car_id",                                                                         comment: "确认收购后关联的在库车辆"
    t.integer  "closing_cost_cents",         limit: 8,                                           comment: "确认收购价"
  end

  add_index "acquisition_car_infos", ["acquirer_id"], name: "index_acquisition_car_infos_on_acquirer_id", using: :btree

  create_table "acquisition_confirmations", force: :cascade, comment: "确认收车清单" do |t|
    t.integer  "acquisition_price_cents", limit: 8,                                        comment: "收购成交价"
    t.date     "acquired_at",                                                              comment: "收购日期"
    t.integer  "company_id",                                                               comment: "入库商家"
    t.integer  "shop_id",                                                                  comment: "入库所属分店"
    t.integer  "acquisition_car_info_id",                                                  comment: "对应的收车信息"
    t.integer  "alliance_id",                                                              comment: "所属联盟"
    t.integer  "cooperate_companies",               default: [],              array: true, comment: "合作收购商家"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "cooperate_users",                   default: [],              array: true, comment: "合作人"
  end

  add_index "acquisition_confirmations", ["acquisition_car_info_id"], name: "index_acquisition_confirmations_on_acquisition_car_info_id", using: :btree
  add_index "acquisition_confirmations", ["company_id"], name: "index_acquisition_confirmations_on_company_id", using: :btree
  add_index "acquisition_confirmations", ["shop_id"], name: "index_acquisition_confirmations_on_shop_id", using: :btree

  create_table "advertisements", force: :cascade, comment: "广告" do |t|
    t.string   "title",                                         comment: "标题"
    t.string   "image_url",                                     comment: "图片地址"
    t.string   "redirect_url",                                  comment: "跳转链接"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "state",        default: "enabled",              comment: "是否启用"
    t.integer  "show_seconds",                                  comment: "广告展示时长"
  end

  create_table "alliance_authority_role_relationships", force: :cascade, comment: "联盟公司角色--用户关联表" do |t|
    t.integer  "authority_role_id"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "alliance_authority_roles", force: :cascade, comment: "联盟公司的权限角色" do |t|
    t.integer  "alliance_company_id"
    t.string   "name",                                                       comment: "名称"
    t.text     "authorities",         default: [],              array: true, comment: "权限"
    t.text     "note",                                                       comment: "备注"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "alliance_channels", force: :cascade, comment: "联盟公司意向渠道" do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.string   "name",                    comment: "名称"
    t.text     "note",                    comment: "备注"
    t.datetime "deleted_at",              comment: "删除时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alliance_companies", force: :cascade, comment: "联盟公司" do |t|
    t.string   "name",                                                       comment: "名称"
    t.string   "contact",                                                    comment: "联系人"
    t.string   "contact_mobile",                                             comment: "联系人电话"
    t.string   "sale_mobile",                                                comment: "销售电话"
    t.string   "logo",                                                       comment: "LOGO"
    t.string   "note",                                                       comment: "备注"
    t.string   "province",                                                   comment: "省份"
    t.string   "city",                                                       comment: "城市"
    t.string   "district",                                                   comment: "区"
    t.string   "street",                                                     comment: "详细地址"
    t.integer  "owner_id",                                                   comment: "公司拥有者ID"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.jsonb    "settings",            default: {},                           comment: "设置"
    t.datetime "deleted_at",                                                 comment: "删除时间"
    t.text     "slogan",                                                     comment: "宣传语"
    t.string   "qrcode",                                                     comment: "商家二维码"
    t.string   "banners",                                       array: true, comment: "网站Banners"
    t.integer  "alliances_count",                                            comment: "联盟数量"
    t.jsonb    "water_mark_position",                                        comment: "水印位置"
    t.string   "water_mark",                                                 comment: "水印图片url"
  end

  create_table "alliance_company_relationships", force: :cascade, comment: "联盟公司关系表" do |t|
    t.integer  "company_id",                  comment: "公司ID"
    t.integer  "alliance_id",                 comment: "联盟ID"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "nickname",                    comment: "公司在联盟中的昵称"
    t.string   "contact",                     comment: "联盟联系人，联盟后台使用"
    t.string   "contact_mobile",              comment: "联盟联系电话，联盟后台使用"
    t.string   "street",                      comment: "联盟看车电话，联盟后台使用"
  end

  add_index "alliance_company_relationships", ["alliance_id"], name: "index_alliance_company_relationships_on_alliance_id", using: :btree
  add_index "alliance_company_relationships", ["company_id"], name: "index_alliance_company_relationships_on_company_id", using: :btree

  create_table "alliance_invitations", force: :cascade do |t|
    t.integer  "alliance_id",                                          comment: "联盟ID"
    t.integer  "company_id",                                           comment: "公司ID"
    t.string   "state",               default: "pending",              comment: "联盟邀请状态"
    t.integer  "assignee_id",                                          comment: "处理人"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "operation_record_id",                                  comment: "联盟邀请操作记录"
  end

  add_index "alliance_invitations", ["alliance_id"], name: "index_alliance_invitations_on_alliance_id", using: :btree
  add_index "alliance_invitations", ["assignee_id"], name: "index_alliance_invitations_on_assignee_id", using: :btree
  add_index "alliance_invitations", ["company_id"], name: "index_alliance_invitations_on_company_id", using: :btree

  create_table "alliance_stock_out_inventories", force: :cascade, comment: "联盟出库清单" do |t|
    t.integer  "from_car_id",                                  comment: "出库车辆 ID"
    t.integer  "to_car_id",                                    comment: "入库(复制)车辆 ID"
    t.integer  "alliance_id",                                  comment: "联盟 ID"
    t.integer  "from_company_id",                              comment: "出库公司 ID"
    t.integer  "to_company_id",                                comment: "入库公司 ID"
    t.date     "completed_at",                                 comment: "出库日期"
    t.integer  "closing_cost_cents",    limit: 8,              comment: "成交价格"
    t.integer  "deposit_cents",         limit: 8,              comment: "定金"
    t.integer  "remaining_money_cents", limit: 8,              comment: "余款"
    t.text     "note",                                         comment: "备注"
    t.date     "refunded_at",                                  comment: "退车时间"
    t.integer  "refunded_price_cents",  limit: 8,              comment: "退车金额"
    t.integer  "seller_id",                                    comment: "成交员工 ID"
    t.boolean  "current",                                      comment: "是否为当前联盟出库记录"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "to_shop_id",                                   comment: "入库分店 ID"
  end

  add_index "alliance_stock_out_inventories", ["alliance_id"], name: "index_alliance_stock_out_inventories_on_alliance_id", using: :btree
  add_index "alliance_stock_out_inventories", ["from_car_id"], name: "index_alliance_stock_out_inventories_on_from_car_id", using: :btree
  add_index "alliance_stock_out_inventories", ["from_company_id"], name: "index_alliance_stock_out_inventories_on_from_company_id", using: :btree
  add_index "alliance_stock_out_inventories", ["seller_id"], name: "index_alliance_stock_out_inventories_on_seller_id", using: :btree
  add_index "alliance_stock_out_inventories", ["to_car_id"], name: "index_alliance_stock_out_inventories_on_to_car_id", using: :btree
  add_index "alliance_stock_out_inventories", ["to_company_id"], name: "index_alliance_stock_out_inventories_on_to_company_id", using: :btree

  create_table "alliance_users", force: :cascade, comment: "联盟公司的用户" do |t|
    t.string   "name",                                      null: false,              comment: "姓名"
    t.string   "username",                                                            comment: "用户名"
    t.string   "password_digest",                           null: false,              comment: "加密密码"
    t.string   "email",                                                               comment: "邮箱"
    t.string   "pass_reset_token",                                                    comment: "重置密码token"
    t.string   "phone",                                                               comment: "手机号码"
    t.string   "state",                 default: "enabled",                           comment: "状态"
    t.datetime "pass_reset_expired_at",                                               comment: "重置密码token过期时间"
    t.datetime "last_sign_in_at",                                                     comment: "最后登录时间"
    t.datetime "current_sign_in_at",                                                  comment: "当前登录时间"
    t.integer  "company_id",                                                          comment: "所属公司"
    t.integer  "manager_id",                                                          comment: "所属经理"
    t.text     "note",                                                                comment: "员工描述"
    t.string   "authority_type",        default: "role",                              comment: "权限选择类型"
    t.text     "authorities",           default: [],                     array: true, comment: "权限"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "deleted_at",                                                          comment: "删除时间"
    t.string   "avatar",                                                              comment: "头像URL"
    t.jsonb    "settings",              default: {},                                  comment: "设置"
    t.string   "first_letter",                                                        comment: "拼音"
  end

  create_table "alliances", force: :cascade do |t|
    t.string   "name",                                             comment: "联盟名称"
    t.integer  "owner_id",                                         comment: "所属公司ID"
    t.datetime "deleted_at",                                       comment: "伪删除时间"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "active_tag",          default: false,              comment: "活跃标识"
    t.boolean  "honesty_tag",                                      comment: "诚信标识"
    t.boolean  "own_brand_tag",                                    comment: "品牌商家标识"
    t.string   "avatar",                                           comment: "联盟头像"
    t.text     "note",                                             comment: "联盟说明"
    t.integer  "companies_count",                                  comment: "公司数量"
    t.integer  "alliance_company_id",                              comment: "外键关联联盟公司"
    t.text     "convention",                                       comment: "联盟公约"
  end

  add_index "alliances", ["alliance_company_id"], name: "index_alliances_on_alliance_company_id", using: :btree
  add_index "alliances", ["own_brand_tag"], name: "index_alliances_on_own_brand_tag", using: :btree

  create_table "ant_queen_record_hubs", force: :cascade, comment: "蚂蚁女王报告" do |t|
    t.string   "vin"
    t.string   "car_brand",                                        comment: "品牌"
    t.integer  "car_brand_id",                                     comment: "蚂蚁女王品牌id"
    t.integer  "number_of_accidents",                              comment: "事故次数"
    t.date     "last_time_to_shop",                                comment: "最后进店时间"
    t.integer  "total_mileage",                                    comment: "行驶的总公里数"
    t.string   "notify_type",                                      comment: "通知类型"
    t.datetime "notify_time",                                      comment: "通知时间"
    t.string   "notify_id",                                        comment: "通知id"
    t.text     "result_description",                               comment: "报告描述"
    t.json     "result_images",                                    comment: "报告图片"
    t.string   "result_status",                                    comment: "报告状态"
    t.datetime "gmt_create",                                       comment: "此次订单创建的时间"
    t.datetime "gmt_finish",                                       comment: "此次订单完成的时间"
    t.integer  "query_id"
    t.boolean  "request_success",     default: false
    t.json     "car_info",                                         comment: "报告描述"
    t.json     "car_status",                                       comment: "报告描述"
    t.json     "query_text",                                       comment: "查询信息"
    t.json     "text_img_json",                                    comment: "报告描述"
    t.json     "text_contents_json",                               comment: "报告描述"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.datetime "request_sent_at",                                  comment: "发送给蚂蚁女王的请求时间"
  end

  add_index "ant_queen_record_hubs", ["vin", "car_brand_id"], name: "index_ant_queen_record_hubs_on_vin_and_car_brand_id", using: :btree

  create_table "ant_queen_records", force: :cascade, comment: "蚂蚁女王记录" do |t|
    t.integer  "company_id",                                                        comment: "公司ID"
    t.integer  "car_id",                                                            comment: "车辆ID"
    t.integer  "shop_id",                                                           comment: "店铺ID"
    t.string   "vin"
    t.string   "state"
    t.integer  "last_fetch_by",                                                     comment: "最后查询的用户ID"
    t.string   "user_name",                                                         comment: "最后查询的用户名"
    t.datetime "last_fetch_at",                                                     comment: "最后查询的时间"
    t.integer  "ant_queen_record_hub_id"
    t.integer  "last_ant_queen_record_hub_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "engine_num"
    t.integer  "car_brand_id"
    t.decimal  "token_price",                  precision: 8, scale: 2
    t.decimal  "pre_token_price",              precision: 8, scale: 2
    t.string   "vin_image"
    t.string   "token_type",                                                        comment: "支付token的类型"
    t.integer  "token_id",                                                          comment: "支付token"
  end

  add_index "ant_queen_records", ["ant_queen_record_hub_id"], name: "index_ant_queen_records_on_ant_queen_record_hub_id", using: :btree
  add_index "ant_queen_records", ["car_id"], name: "index_ant_queen_records_on_car_id", using: :btree
  add_index "ant_queen_records", ["company_id"], name: "index_ant_queen_records_on_company_id", using: :btree
  add_index "ant_queen_records", ["shop_id"], name: "index_ant_queen_records_on_shop_id", using: :btree
  add_index "ant_queen_records", ["vin"], name: "index_ant_queen_records_on_vin", using: :btree

  create_table "app_version_company_relationships", force: :cascade, comment: "app版本公司关系表" do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.integer  "version_id",              comment: "版本控制ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "app_version_company_relationships", ["company_id"], name: "index_app_version_company_relationships_on_company_id", using: :btree
  add_index "app_version_company_relationships", ["version_id"], name: "index_app_version_company_relationships_on_version_id", using: :btree

  create_table "app_versions", force: :cascade, comment: "app版本控制" do |t|
    t.string   "version_number",                                     comment: "版本号"
    t.string   "version_type",                                       comment: "版本类型"
    t.text     "note",                                               comment: "发布说明"
    t.string   "android_source",                                     comment: "安卓版本下载地址"
    t.string   "ipa_source",                                         comment: "苹果版本ipa地址"
    t.string   "plist_source",                                       comment: "苹果版本plist地址"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "version_category", default: "chelaike",              comment: "版本类别，如车来客与鸿升车来客"
    t.integer  "app_id"
    t.boolean  "force_update",     default: false,                   comment: "强制更新"
  end

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "alias"
    t.string   "logo"
    t.string   "slogan"
    t.string   "domain"
    t.string   "pc_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authority_role_relationships", force: :cascade, comment: "权限角色-用户 中间表" do |t|
    t.integer "authority_role_id"
    t.integer "user_id"
  end

  add_index "authority_role_relationships", ["authority_role_id"], name: "index_authority_role_relationships_on_authority_role_id", using: :btree
  add_index "authority_role_relationships", ["user_id"], name: "index_authority_role_relationships_on_user_id", using: :btree

  create_table "authority_roles", force: :cascade, comment: "权限名称" do |t|
    t.integer  "company_id"
    t.string   "name",                                               comment: "名称"
    t.text     "authorities", default: [],              array: true, comment: "权限"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "note",                                               comment: "备注"
  end

  add_index "authority_roles", ["company_id"], name: "index_authority_roles_on_company_id", using: :btree
  add_index "authority_roles", ["name"], name: "index_authority_roles_on_name", using: :btree

  create_table "buyer_appointments", force: :cascade, comment: "车辆预约" do |t|
    t.integer  "car_id",                      comment: "车辆ID"
    t.string   "customer_name",               comment: "客户姓名"
    t.string   "customer_phone",              comment: "客户电话"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "buyer_appointments", ["car_id"], name: "index_buyer_appointments_on_car_id", using: :btree

  create_table "car_alliance_blacklists", force: :cascade, comment: "不允许车辆在某个平台展示" do |t|
    t.integer  "car_id"
    t.integer  "alliance_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "car_alliance_blacklists", ["alliance_id"], name: "index_car_alliance_blacklists_on_alliance_id", using: :btree
  add_index "car_alliance_blacklists", ["car_id"], name: "index_car_alliance_blacklists_on_car_id", using: :btree

  create_table "car_appointments", force: :cascade, comment: "预约看车" do |t|
    t.integer  "car_id",                  comment: "车辆ID"
    t.string   "phone",                   comment: "手机"
    t.string   "name",                    comment: "姓名"
    t.integer  "seller_id",               comment: "销售员ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id",              comment: "公司ID"
  end

  add_index "car_appointments", ["car_id"], name: "index_car_appointments_on_car_id", using: :btree
  add_index "car_appointments", ["seller_id"], name: "index_car_appointments_on_seller_id", using: :btree

  create_table "car_cancel_reservations", force: :cascade, comment: "取消预定表" do |t|
    t.integer  "car_id"
    t.boolean  "current",                          default: true,              comment: "是否是当前退定"
    t.integer  "cancelable_price_cents", limit: 8,                             comment: "退款金额"
    t.datetime "canceled_at",                                                  comment: "退定日期"
    t.string   "note",                                                         comment: "备注"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "car_info_publish_records", force: :cascade, comment: "收车信息发送记录" do |t|
    t.integer  "acquisition_car_info_id",              comment: "对应的收车信息"
    t.integer  "chatable_id",                          comment: "发送到的群组或个人"
    t.string   "chatable_type",                        comment: "发送到的群组或个人"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "car_info_publish_records", ["acquisition_car_info_id"], name: "index_car_info_publish_records_on_acquisition_car_info_id", using: :btree
  add_index "car_info_publish_records", ["chatable_type", "chatable_id"], name: "index_car_info_publish_records_on_chatable_type_and_chatable_id", using: :btree

  create_table "car_price_histories", force: :cascade do |t|
    t.integer  "car_id",                                                                    comment: "车辆ID"
    t.integer  "user_id",                                                                   comment: "调价人ID"
    t.string   "user_name",                                                                 comment: "调价人"
    t.integer  "previous_show_price_cents",             limit: 8,                           comment: "旧展厅价格"
    t.integer  "show_price_cents",                      limit: 8,                           comment: "展厅价格"
    t.integer  "previous_online_price_cents",           limit: 8,                           comment: "旧网络价格"
    t.integer  "online_price_cents",                    limit: 8,                           comment: "网络价格"
    t.integer  "previous_sales_minimun_price_cents",    limit: 8,                           comment: "旧销售底价"
    t.integer  "sales_minimun_price_cents",             limit: 8,                           comment: "新销售底价"
    t.integer  "previous_manager_price_cents",          limit: 8,                           comment: "旧经理底价"
    t.integer  "manager_price_cents",                   limit: 8,                           comment: "新经理底价"
    t.integer  "previous_alliance_minimun_price_cents", limit: 8,                           comment: "旧联盟底价"
    t.integer  "alliance_minimun_price_cents",          limit: 8,                           comment: "新联盟底价"
    t.integer  "yellow_stock_warning_days",                       default: 30,              comment: "库存预警时间"
    t.text     "note",                                                                      comment: "说明"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "red_stock_warning_days",                          default: 45,              comment: "红色预警"
  end

  add_index "car_price_histories", ["car_id"], name: "index_car_price_histories_on_car_id", using: :btree
  add_index "car_price_histories", ["user_id"], name: "index_car_price_histories_on_user_id", using: :btree

  create_table "car_publish_records", force: :cascade do |t|
    t.integer  "company_id",                                        comment: "公司ID"
    t.integer  "car_id",                                            comment: "发布车辆ID"
    t.integer  "user_id",                                           comment: "发布者ID"
    t.string   "state",         default: "processing",              comment: "发布状态"
    t.string   "error_message",                                     comment: "错误信息"
    t.string   "publish_state",                                     comment: "车辆在对应平台的状态"
    t.string   "type",                                              comment: "STI"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "current",       default: false,                     comment: "是否是当前的记录"
    t.string   "contactor",                                         comment: "各平台的联系人"
    t.jsonb    "published_id",                                      comment: "同步到平台的标识，可能为{id: 1234, company_id:4321}"
  end

  add_index "car_publish_records", ["car_id"], name: "index_car_publish_records_on_car_id", using: :btree
  add_index "car_publish_records", ["company_id"], name: "index_car_publish_records_on_company_id", using: :btree
  add_index "car_publish_records", ["user_id"], name: "index_car_publish_records_on_user_id", using: :btree

  create_table "car_reservations", force: :cascade, comment: "车辆预定" do |t|
    t.integer  "car_id",                                                               comment: "车辆ID"
    t.string   "sales_type",                                                           comment: "销售类型"
    t.datetime "reserved_at",                                                          comment: "预约时间"
    t.integer  "customer_channel_id",                                                  comment: "客户来源"
    t.integer  "seller_id",                                                            comment: "成交员工"
    t.integer  "closing_cost_cents",             limit: 8,                             comment: "成交价格"
    t.integer  "deposit_cents",                  limit: 8,                             comment: "定金"
    t.text     "note",                                                                 comment: "备注"
    t.string   "customer_location_province",                                           comment: "客户归属地省份"
    t.string   "customer_location_city",                                               comment: "客户归属地城市"
    t.string   "customer_location_address",                                            comment: "客户归属地详细地址"
    t.string   "customer_name",                                                        comment: "客户姓名"
    t.string   "customer_phone",                                                       comment: "客户电话"
    t.string   "customer_idcard",                                                      comment: "客户证件号"
    t.boolean  "current",                                  default: true,              comment: "是否是当前预定"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "cancelable_price_cents",         limit: 8,                             comment: "退款金额"
    t.datetime "canceled_at",                                                          comment: "退定日期"
    t.string   "seller_name",                                                          comment: "销售员名字"
    t.integer  "shop_id",                                                              comment: "分店ID"
    t.integer  "customer_id",                                                          comment: "客户ID"
    t.boolean  "proxy_insurance",                                                      comment: "代办保险"
    t.integer  "insurance_company_id",                                                 comment: "保险公司"
    t.integer  "commercial_insurance_fee_cents",                                       comment: "商业险"
    t.integer  "compulsory_insurance_fee_cents",                                       comment: "交强险"
  end

  add_index "car_reservations", ["car_id"], name: "index_car_reservations_on_car_id", using: :btree
  add_index "car_reservations", ["current"], name: "index_car_reservations_on_current", using: :btree
  add_index "car_reservations", ["customer_channel_id"], name: "index_car_reservations_on_customer_channel_id", using: :btree
  add_index "car_reservations", ["reserved_at"], name: "index_car_reservations_on_reserved_at", using: :btree
  add_index "car_reservations", ["sales_type"], name: "index_car_reservations_on_sales_type", using: :btree
  add_index "car_reservations", ["seller_id"], name: "index_car_reservations_on_seller_id", using: :btree

  create_table "car_state_histories", force: :cascade, comment: "车辆状态修改历史" do |t|
    t.integer  "car_id",                              comment: "车辆ID"
    t.string   "previous_state",                      comment: "上一个状态"
    t.string   "state",                               comment: "当前状况"
    t.boolean  "sellable",                            comment: "是否可售"
    t.datetime "occurred_at",                         comment: "修改时间"
    t.text     "note",                                comment: "描述"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "predicted_restocked_at",              comment: "预计回厅时间"
  end

  add_index "car_state_histories", ["car_id"], name: "index_car_state_histories_on_car_id", using: :btree

  create_table "cars", force: :cascade, comment: "车辆" do |t|
    t.integer  "company_id"
    t.integer  "shop_id"
    t.integer  "acquirer_id",                                                                        comment: "收购员"
    t.datetime "acquired_at",                                                                        comment: "收购日期"
    t.integer  "channel_id",                                                                         comment: "收购渠道"
    t.string   "acquisition_type",                                                                   comment: "收购类型"
    t.integer  "acquisition_price_cents",        limit: 8,                                           comment: "收购价"
    t.string   "stock_number",                                                                       comment: "库存编号"
    t.string   "vin",                                                                                comment: "车架号"
    t.string   "state",                                                                              comment: "车辆状态"
    t.string   "state_note",                                                                         comment: "车辆备注"
    t.string   "brand_name",                                                                         comment: "品牌名称"
    t.string   "manufacturer_name",                                                                  comment: "厂商名称"
    t.string   "series_name",                                                                        comment: "车系名称"
    t.string   "style_name",                                                                         comment: "车型名称"
    t.string   "car_type",                                                                           comment: "车辆类型"
    t.integer  "door_count",                                                                         comment: "门数"
    t.float    "displacement",                                                                       comment: "排气量"
    t.string   "fuel_type",                                                                          comment: "燃油类型"
    t.boolean  "is_turbo_charger",                                                                   comment: "涡轮增压"
    t.string   "transmission",                                                                       comment: "变速箱"
    t.string   "exterior_color",                                                                     comment: "外饰颜色"
    t.string   "interior_color",                                                                     comment: "内饰颜色"
    t.float    "mileage",                                                                            comment: "表显里程(万公里)"
    t.float    "mileage_in_fact",                                                                    comment: "实际里程(万公里)"
    t.string   "emission_standard",                                                                  comment: "排放标准"
    t.string   "license_info",                                                                       comment: "牌证信息"
    t.date     "licensed_at",                                                                        comment: "首次上牌日期"
    t.date     "manufactured_at",                                                                    comment: "出厂日期"
    t.integer  "show_price_cents",               limit: 8,                                           comment: "展厅价格"
    t.integer  "online_price_cents",             limit: 8,                                           comment: "网络标价"
    t.integer  "sales_minimun_price_cents",      limit: 8,                                           comment: "销售底价"
    t.integer  "manager_price_cents",            limit: 8,                                           comment: "经理价"
    t.integer  "alliance_minimun_price_cents",   limit: 8,                                           comment: "联盟底价"
    t.integer  "new_car_guide_price_cents",      limit: 8,                                           comment: "新车指导价"
    t.integer  "new_car_additional_price_cents", limit: 8,                                           comment: "新车加价"
    t.float    "new_car_discount",                                                                   comment: "新车优惠折扣"
    t.integer  "new_car_final_price_cents",      limit: 8,                                           comment: "新车完税价"
    t.text     "interior_note",                                                                      comment: "车辆内部描述"
    t.integer  "star_rating",                                                                        comment: "车辆星级"
    t.integer  "warranty_id",                                                                        comment: "质保等级"
    t.integer  "warranty_fee_cents",             limit: 8,                                           comment: "质保费用"
    t.boolean  "is_fixed_price",                                                                     comment: "是否一口价"
    t.boolean  "allowed_mortgage",                                                                   comment: "是否可按揭"
    t.text     "mortgage_note",                                                                      comment: "按揭说明"
    t.text     "selling_point",                                                                      comment: "卖点描述"
    t.float    "maintain_mileage",                                                                   comment: "保养里程"
    t.boolean  "has_maintain_history",                                                               comment: "有无保养记录"
    t.string   "new_car_warranty",                                                                   comment: "新车质保"
    t.text     "standard_equipment",                       default: [],                 array: true, comment: "厂家标准配置"
    t.text     "personal_equipment",                       default: [],                 array: true, comment: "车主个性配置"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "stock_age_days",                           default: 0,                               comment: "库龄"
    t.integer  "age",                                                                                comment: "车龄"
    t.boolean  "sellable",                                 default: true,                            comment: "是否可售"
    t.jsonb    "states_statistic",                         default: {},                              comment: "状态统计"
    t.datetime "state_changed_at",                                                                   comment: "状态修改时间"
    t.integer  "yellow_stock_warning_days",                default: 30,                              comment: "库存预警"
    t.string   "imported"
    t.datetime "reserved_at",                                                                        comment: "预约时间"
    t.string   "consignor_name",                                                                     comment: "寄卖人"
    t.string   "consignor_phone",                                                                    comment: "寄卖人电话"
    t.integer  "consignor_price_cents",          limit: 8,                                           comment: "寄卖价格"
    t.datetime "deleted_at",                                                                         comment: "删除时间"
    t.datetime "stock_out_at",                                                                       comment: "出库时间"
    t.integer  "closing_cost_cents",             limit: 8,                                           comment: "成交价格"
    t.hstore   "manufacturer_configuration"
    t.datetime "predicted_restocked_at",                                                             comment: "预计回厅时间"
    t.boolean  "reserved",                                 default: false,                           comment: "是否已经预定"
    t.text     "configuration_note",                                                                 comment: "车型配置描述"
    t.string   "name",                                                                               comment: "车辆名称"
    t.string   "name_pinyin",                                                                        comment: "车辆名称拼音"
    t.string   "attachments",                              default: [],                 array: true, comment: "车辆附件"
    t.integer  "red_stock_warning_days",                   default: 45,                              comment: "红色预警"
    t.string   "level",                                                                              comment: "车辆等级"
    t.string   "current_plate_number",                                                               comment: "现车牌(冗余牌证表)"
    t.string   "system_name",                                                                        comment: "车辆系统名"
    t.boolean  "is_special_offer",                         default: false,                           comment: "是否特价"
    t.integer  "estimated_gross_profit_cents",   limit: 8,                                           comment: "预期毛利"
    t.float    "estimated_gross_profit_rate",                                                        comment: "预期毛利率"
    t.text     "fee_detail",                                                                         comment: "费用情况"
    t.integer  "current_publish_records_count",            default: 0,     null: false
    t.integer  "images_count",                             default: 0,                               comment: "图片数量"
    t.integer  "seller_id",                                                                          comment: "成交员工"
    t.string   "cover_url",                                                                          comment: "车辆封面图"
    t.string   "alliance_cover_url",                                                                 comment: "联盟封面图"
    t.boolean  "is_onsale",                                default: false,                           comment: "车辆是否特卖"
    t.integer  "onsale_price_cents",             limit: 8,                                           comment: "特卖价格"
    t.string   "onsale_description",                                                                 comment: "特卖描述"
    t.integer  "owner_company_id",                                                                   comment: "归属车商公司ID"
  end

  add_index "cars", ["acquired_at"], name: "index_cars_on_acquired_at", using: :btree
  add_index "cars", ["acquirer_id"], name: "index_cars_on_acquirer_id", using: :btree
  add_index "cars", ["acquisition_type"], name: "index_cars_on_acquisition_type", using: :btree
  add_index "cars", ["brand_name"], name: "index_cars_on_brand_name", using: :btree
  add_index "cars", ["car_type"], name: "index_cars_on_car_type", using: :btree
  add_index "cars", ["channel_id"], name: "index_cars_on_channel_id", using: :btree
  add_index "cars", ["company_id"], name: "index_cars_on_company_id", using: :btree
  add_index "cars", ["created_at"], name: "index_cars_on_created_at", using: :btree
  add_index "cars", ["deleted_at", "reserved"], name: "index_cars_on_deleted_at_and_reserved", unique: true, where: "((deleted_at IS NULL) AND (NOT reserved))", using: :btree
  add_index "cars", ["mileage"], name: "index_cars_on_mileage", using: :btree
  add_index "cars", ["online_price_cents"], name: "index_cars_on_online_price_cents", using: :btree
  add_index "cars", ["series_name"], name: "index_cars_on_series_name", using: :btree
  add_index "cars", ["shop_id"], name: "index_cars_on_shop_id", using: :btree
  add_index "cars", ["show_price_cents"], name: "index_cars_on_show_price_cents", using: :btree
  add_index "cars", ["state", "company_id"], name: "index_cars_on_state_and_company_id", using: :btree
  add_index "cars", ["stock_number"], name: "index_cars_on_stock_number", using: :btree
  add_index "cars", ["stock_out_at"], name: "index_cars_on_stock_out_at", using: :btree
  add_index "cars", ["style_name"], name: "index_cars_on_style_name", using: :btree
  add_index "cars", ["updated_at"], name: "index_cars_on_updated_at", using: :btree
  add_index "cars", ["vin"], name: "index_cars_on_vin", using: :btree

  create_table "cha_doctor_record_hubs", force: :cascade, comment: "查博士报告" do |t|
    t.string   "vin",                                           comment: "vin码"
    t.string   "brand_name",                                    comment: "品牌"
    t.string   "engine_no",                                     comment: "发动机号"
    t.string   "license_plate",                                 comment: "车牌号"
    t.datetime "sent_at",                                       comment: "请求发送时间"
    t.string   "order_id",                                      comment: "订单ID"
    t.datetime "make_report_at",                                comment: "报告生成时间"
    t.string   "report_no",                                     comment: "报告编号"
    t.jsonb    "report_details",      default: [],              comment: "详细报告"
    t.string   "pc_url",                                        comment: "生成报告的电脑端URL"
    t.string   "mobile_url",                                    comment: "生成报告的手机端URL"
    t.datetime "fetch_info_at",                                 comment: "拉取报告的时间"
    t.datetime "notify_at",                                     comment: "通知回调时间"
    t.string   "order_status",                                  comment: "查询结果状态码"
    t.string   "order_message",                                 comment: "查询结果对应消息"
    t.string   "notify_status",                                 comment: "异步回调结果状态"
    t.string   "notify_message",                                comment: "异步回调结果消息"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "order_state",                                   comment: "购买报表同步返回结果的状态"
    t.string   "notify_state",                                  comment: "购买报表异步通知结果的状态"
    t.string   "series_name",                                   comment: "车系名"
    t.string   "style_name",                                    comment: "车型"
    t.jsonb    "summany_status_data",                           comment: "概况的状态"
  end

  create_table "cha_doctor_records", force: :cascade do |t|
    t.integer  "company_id",                                                                            comment: "公司ID"
    t.integer  "car_id",                                                                                comment: "车辆ID"
    t.integer  "shop_id",                                                                               comment: "店铺ID"
    t.string   "vin"
    t.string   "state"
    t.string   "user_name",                                                                             comment: "查询的用户名"
    t.integer  "user_id",                                                                               comment: "查询的用户ID"
    t.datetime "fetch_at",                                                                              comment: "拉取报告的时间"
    t.integer  "cha_doctor_record_hub_id",                                                              comment: "所属报告"
    t.integer  "last_cha_doctor_record_hub_id",                                                         comment: "最新更新的报告"
    t.string   "engine_num",                                                                            comment: "发动机号"
    t.decimal  "token_price",                   precision: 8, scale: 2
    t.string   "vin_image",                                                                             comment: "vin码图片"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.string   "action_type",                                           default: "new",                 comment: "记录的查询类型"
    t.string   "payment_state",                                         default: "unpaid",              comment: "支付状态"
    t.datetime "request_at",                                                                            comment: "请求时间"
    t.datetime "response_at",                                                                           comment: "返回时间"
    t.string   "token_type"
    t.integer  "token_id"
  end

  create_table "channels", force: :cascade, comment: "渠道设置" do |t|
    t.integer  "company_id",                comment: "公司ID"
    t.string   "name",                      comment: "名称"
    t.text     "note",                      comment: "备注"
    t.datetime "deleted_at",                comment: "删除时间"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "company_type",              comment: "渠道所属公司多态"
  end

  add_index "channels", ["company_id"], name: "index_channels_on_company_id", using: :btree

  create_table "chat_groups", force: :cascade do |t|
    t.integer  "organize_id",                                   comment: "所属组织"
    t.string   "organize_type",                                 comment: "所属组织"
    t.string   "name",                             null: false, comment: "群组名称"
    t.string   "state",         default: "enable", null: false, comment: "群组状态"
    t.string   "group_type",    default: "sale",   null: false, comment: "群组类型"
    t.integer  "owner_id",                         null: false, comment: "群主"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "logo",                                          comment: "群组logo"
  end

  add_index "chat_groups", ["organize_id", "organize_type", "group_type"], name: "uni_chat_group_organize", unique: true, using: :btree
  add_index "chat_groups", ["owner_id"], name: "index_chat_groups_on_owner_id", using: :btree

  create_table "chat_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "nick_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "target_id"
    t.string   "target_type"
  end

  add_index "chat_sessions", ["target_id", "target_type", "user_id"], name: "uniq_chat_sessions", unique: true, using: :btree
  add_index "chat_sessions", ["user_id"], name: "index_chat_sessions_on_user_id", using: :btree

  create_table "che168_publish_records", force: :cascade, comment: "che168发布记录" do |t|
    t.integer  "company_id",                                       comment: "公司ID"
    t.integer  "car_id",                                           comment: "发布车辆ID"
    t.integer  "user_id",                                          comment: "发布者ID"
    t.integer  "che168_id",                                        comment: "che168对应车辆ID"
    t.string   "state",           default: "pending",              comment: "发布状态"
    t.string   "error_message",                                    comment: "错误信息"
    t.text     "command",                                          comment: "发布命令记录"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "publish_state",   default: "pending",              comment: "che168车辆状态"
    t.string   "publish_message",                                  comment: "che168车辆状态信息"
    t.boolean  "syncable",        default: false,                  comment: "是否同步"
    t.string   "seller_id",       default: "",                     comment: "销售员ID"
  end

  add_index "che168_publish_records", ["car_id"], name: "index_che168_publish_records_on_car_id", using: :btree
  add_index "che168_publish_records", ["che168_id"], name: "index_che168_publish_records_on_che168_id", using: :btree
  add_index "che168_publish_records", ["company_id"], name: "index_che168_publish_records_on_company_id", using: :btree
  add_index "che168_publish_records", ["user_id"], name: "index_che168_publish_records_on_user_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "province_id"
    t.integer  "level"
    t.string   "zip_code"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["level"], name: "index_cities_on_level", using: :btree
  add_index "cities", ["name"], name: "index_cities_on_name", using: :btree
  add_index "cities", ["pinyin"], name: "index_cities_on_pinyin", using: :btree
  add_index "cities", ["pinyin_abbr"], name: "index_cities_on_pinyin_abbr", using: :btree
  add_index "cities", ["province_id"], name: "index_cities_on_province_id", using: :btree
  add_index "cities", ["zip_code"], name: "index_cities_on_zip_code", using: :btree

  create_table "companies", force: :cascade, comment: "公司" do |t|
    t.string   "name",                                                              comment: "名称"
    t.string   "contact",                                                           comment: "联系人"
    t.string   "contact_mobile",                                                    comment: "联系人电话"
    t.string   "acquisition_mobile",                                                comment: "收购电话"
    t.string   "sale_mobile",                                                       comment: "销售电话"
    t.string   "logo",                                                              comment: "LOGO"
    t.string   "note",                                                              comment: "备注"
    t.string   "province",                                                          comment: "省份"
    t.string   "city",                                                              comment: "城市"
    t.string   "district",                                                          comment: "区"
    t.string   "street",                                                            comment: "详细地址"
    t.integer  "owner_id",                                                          comment: "公司拥有者ID"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.jsonb    "settings",                default: {},                              comment: "设置"
    t.datetime "deleted_at",                                                        comment: "删除时间"
    t.string   "md5_name",                                                          comment: "兼容老系统的名称MD5值"
    t.text     "slogan",                                                            comment: "宣传语"
    t.integer  "alliances_count",                                                   comment: "联盟数量"
    t.integer  "cars_count",                                                        comment: "车辆数量"
    t.boolean  "active_tag",              default: false,                           comment: "活跃标识"
    t.boolean  "honesty_tag",                                                       comment: "诚信标识"
    t.boolean  "own_brand_tag",                                                     comment: "品牌商家标识"
    t.string   "app_secret",                                                        comment: "商家secret"
    t.string   "youhaosuda_shop_token",                                             comment: "友好速搭商铺Token"
    t.integer  "open_alliance_id",                                                  comment: "开放联盟ID"
    t.string   "erp_id",                                                            comment: "ERP 识别号"
    t.string   "erp_url",                                                           comment: "ERP 通知地址"
    t.jsonb    "che168_profile",          default: {},                              comment: "che168信息"
    t.string   "qrcode",                                                            comment: "商家二维码"
    t.string   "banners",                                              array: true, comment: "网站Banners"
    t.integer  "shops_count",             default: 0
    t.integer  "alliance_company_id",                                               comment: "所属品牌联盟的联盟公司"
    t.string   "official_website_url",                                              comment: "官网地址"
    t.jsonb    "financial_configuration", default: {},                              comment: "财务设置"
    t.integer  "alliance_manager_id",                                               comment: "这家公司所对应的联盟管理公司ID"
    t.string   "facade",                  default: "",                              comment: "公司的门头照片"
    t.decimal  "industry_rating",         default: 3.0,                             comment: "默认行业风评等级"
    t.decimal  "assets_debts_rating",     default: 0.6,                             comment: "默认资产负债率"
  end

  add_index "companies", ["alliance_company_id"], name: "index_companies_on_alliance_company_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_id",                                        comment: "所属用户"
    t.integer  "target_id",                         null: false, comment: "会话类型"
    t.string   "conversation_type",                 null: false, comment: "目标 Id。根据不同的 conversationType，可能是用户 Id、讨论组 Id、群组 Id 或聊天室 Id。"
    t.boolean  "is_top",            default: false, null: false, comment: "置顶"
    t.boolean  "is_blocked",        default: false, null: false, comment: "免打扰"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

  create_table "cooperation_companies", force: :cascade, comment: "合作商家" do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.string   "name",                    comment: "名称"
    t.datetime "deleted_at",              comment: "删除时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cooperation_companies", ["company_id"], name: "index_cooperation_companies_on_company_id", using: :btree

  create_table "cooperation_company_relationships", force: :cascade, comment: "合作商家关联表" do |t|
    t.integer  "car_id",                                         comment: "车辆ID"
    t.integer  "cooperation_company_id",                         comment: "合作商家ID"
    t.integer  "cooperation_price_cents", limit: 8,              comment: "合作价格"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "cooperation_company_relationships", ["car_id"], name: "index_cooperation_company_relationships_on_car_id", using: :btree
  add_index "cooperation_company_relationships", ["cooperation_company_id"], name: "relationships_on_company_id", using: :btree

  create_table "customers", force: :cascade, comment: "客户" do |t|
    t.integer  "company_id",                                                               comment: "公司ID"
    t.string   "name",                                                                     comment: "姓名"
    t.text     "note",                                                                     comment: "备注"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "phone",                                                                    comment: "客户主要联系电话"
    t.string   "phones",              default: [],                            array: true, comment: "客户联系电话"
    t.string   "gender",                                                                   comment: "性别"
    t.string   "id_number",                                                                comment: "证件号"
    t.string   "avatar",                                                                   comment: "客户头像"
    t.integer  "user_id",                                                                  comment: "客户所属员工ID"
    t.string   "first_letter",                                                             comment: "客户姓名首字母"
    t.datetime "deleted_at"
    t.string   "source",              default: "user_operation",                           comment: "客户产生来源"
    t.integer  "alliance_user_id",                                                         comment: "联盟公司员工ID"
    t.integer  "alliance_company_id",                                                      comment: "联盟公司ID"
    t.jsonb    "memory_dates",                                                             comment: "纪念节日"
  end

  add_index "customers", ["alliance_company_id"], name: "index_customers_on_alliance_company_id", using: :btree
  add_index "customers", ["alliance_user_id"], name: "index_customers_on_alliance_user_id", using: :btree
  add_index "customers", ["company_id"], name: "index_customers_on_company_id", using: :btree

  create_table "daily_active_records", force: :cascade, comment: "统计用户日活" do |t|
    t.integer  "user_id",                 comment: "user_id"
    t.string   "request_ip",              comment: "请求的来源IP"
    t.string   "url",                     comment: "请求的地址"
    t.string   "region",                  comment: "省份"
    t.string   "city",                    comment: "城市"
    t.integer  "company_id",              comment: "用户所属店家的id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "url_path",                comment: "请求的接口"
    t.jsonb    "url_query",               comment: "请求的参数"
  end

  add_index "daily_active_records", ["company_id"], name: "index_daily_active_records_on_company_id", using: :btree

  create_table "dashboard_company_properties", force: :cascade, comment: "公司运营管理属性表" do |t|
    t.integer  "company_id",                                           comment: "公司ID"
    t.integer  "staff_id",                                             comment: "服务顾问ID"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.jsonb    "labels",     default: [],                 array: true, comment: "车商标签"
    t.boolean  "active_tag", default: false,                           comment: "车商考核活跃标记"
  end

  add_index "dashboard_company_properties", ["company_id"], name: "index_dashboard_company_properties_on_company_id", using: :btree
  add_index "dashboard_company_properties", ["staff_id"], name: "index_dashboard_company_properties_on_staff_id", using: :btree

  create_table "dashboard_company_staff_relationships", force: :cascade, comment: "公司服务顾问关系表" do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.integer  "staff_id",                comment: "服务顾问ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dashboard_company_staff_relationships", ["company_id"], name: "index_dashboard_company_staff_relationships_on_company_id", using: :btree
  add_index "dashboard_company_staff_relationships", ["staff_id"], name: "index_dashboard_company_staff_relationships_on_staff_id", using: :btree

  create_table "dashboard_operation_records", force: :cascade do |t|
    t.integer  "staff_id",                    comment: "操作员工ID"
    t.string   "operation_type",              comment: "操作类型"
    t.jsonb    "content",                     comment: "操作内容"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "dashboard_operation_records", ["staff_id"], name: "index_dashboard_operation_records_on_staff_id", using: :btree

  create_table "dashboard_staffs", force: :cascade, comment: "员工表" do |t|
    t.string   "phone",                                       comment: "员工手机号"
    t.string   "name",                                        comment: "员工姓名"
    t.string   "state",      default: "enabled",              comment: "员工状态"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "manager_id",                                  comment: "所属主管ID"
    t.string   "role",                                        comment: "角色"
  end

  create_table "dashenglaile_record_hubs", force: :cascade, comment: "大圣来了报告" do |t|
    t.string   "vin",                                              comment: "vin码"
    t.string   "engine_num",                                       comment: "发动机号"
    t.integer  "car_brand_id",                                     comment: "大圣来了品牌 ID"
    t.string   "license_plate",                                    comment: "车牌号"
    t.datetime "sent_at",                                          comment: "请求发送时间"
    t.datetime "last_time_to_shop",                                comment: "最后进店时间"
    t.integer  "total_mileage",                                    comment: "行驶的总公里数"
    t.integer  "number_of_accidents",                              comment: "事故次数"
    t.string   "car_brand",                                        comment: "品牌"
    t.text     "result_description",                               comment: "报告描述"
    t.json     "result_images",                                    comment: "报告图片"
    t.string   "result_status",                                    comment: "报告状态"
    t.datetime "gmt_create",                                       comment: "此次订单创建的时间"
    t.datetime "gmt_finish",                                       comment: "此次订单完成的时间"
    t.string   "order_id",                                         comment: "订单ID"
    t.json     "result_content",                                   comment: "报告内容"
    t.json     "result_report",                                    comment: "报告总结"
    t.datetime "fetch_info_at",                                    comment: "拉取报告的时间"
    t.datetime "make_report_at",                                   comment: "报告生成时间"
    t.datetime "notify_time",                                      comment: "通知回调时间"
    t.string   "notify_type",                                      comment: "通知类型"
    t.integer  "notify_id",                                        comment: "推送校验 ID"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "request_success",     default: false,              comment: "请求是否成功"
  end

  create_table "dashenglaile_records", force: :cascade, comment: "大圣来了记录" do |t|
    t.integer  "company_id",                                                                              comment: "公司ID"
    t.integer  "car_id",                                                                                  comment: "车辆ID"
    t.integer  "shop_id",                                                                                 comment: "店铺ID"
    t.string   "vin",                                                                                     comment: "vin码"
    t.string   "engine_num",                                                                              comment: "发动机号"
    t.integer  "car_brand_id",                                                                            comment: "大圣来了品牌 ID"
    t.string   "state",                                                                                   comment: "查询状态"
    t.integer  "last_fetch_by",                                                                           comment: "最后查询的用户ID"
    t.string   "user_name",                                                                               comment: "最后查询的用户名"
    t.datetime "last_fetch_at",                                                                           comment: "最后查询的时间"
    t.integer  "dashenglaile_record_hub_id",                                                              comment: "所属报告"
    t.integer  "last_dashenglaile_record_hub_id",                                                         comment: "最近更新的报告"
    t.decimal  "token_price",                     precision: 8, scale: 2,                                 comment: "查询价格"
    t.string   "vin_image",                                                                               comment: "vin码图片地址"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.string   "action_type",                                             default: "new",                 comment: "记录的查询类型"
    t.string   "payment_state",                                           default: "unpaid",              comment: "支付状态"
    t.decimal  "pre_token_price",                 precision: 8, scale: 2,                                 comment: "原价"
    t.datetime "request_at",                                                                              comment: "请求时间"
    t.datetime "response_at",                                                                             comment: "返回时间"
    t.string   "token_type",                                                                              comment: "支付token的类型"
    t.integer  "token_id",                                                                                comment: "支付token"
  end

  add_index "dashenglaile_records", ["car_id"], name: "index_dashenglaile_records_on_car_id", using: :btree
  add_index "dashenglaile_records", ["company_id"], name: "index_dashenglaile_records_on_company_id", using: :btree
  add_index "dashenglaile_records", ["dashenglaile_record_hub_id"], name: "index_dashenglaile_records_on_dashenglaile_record_hub_id", using: :btree
  add_index "dashenglaile_records", ["last_dashenglaile_record_hub_id"], name: "index_dashenglaile_records_on_last_dashenglaile_record_hub_id", using: :btree
  add_index "dashenglaile_records", ["last_fetch_by"], name: "index_dashenglaile_records_on_last_fetch_by", using: :btree
  add_index "dashenglaile_records", ["shop_id"], name: "index_dashenglaile_records_on_shop_id", using: :btree

  create_table "detection_configs", force: :cascade, comment: "检测报告平台配置" do |t|
    t.string   "platform_name",              comment: "平台名"
    t.string   "key",                        comment: "平台key"
    t.integer  "c_id",                       comment: "对应商家id"
    t.string   "c_code",                     comment: "商家code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "detection_reports", force: :cascade, comment: "检测报告" do |t|
    t.string   "report_type",                comment: "报告类型"
    t.integer  "car_id",                     comment: "关联的车辆id"
    t.string   "url",                        comment: "生成报告的地址"
    t.string   "platform_name",              comment: "对应的检测平台名"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "images_count"
  end

  create_table "districts", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["city_id"], name: "index_districts_on_city_id", using: :btree
  add_index "districts", ["name"], name: "index_districts_on_name", using: :btree
  add_index "districts", ["pinyin"], name: "index_districts_on_pinyin", using: :btree
  add_index "districts", ["pinyin_abbr"], name: "index_districts_on_pinyin_abbr", using: :btree

  create_table "dw_acquired_at_dimensions", force: :cascade, comment: "收购时间纬度" do |t|
    t.datetime "acquired_at",       comment: "收购时间"
    t.date     "acquired_at_date",  comment: "收购日期"
    t.integer  "acquired_at_year",  comment: "收购日期(年)"
    t.integer  "acquired_at_month", comment: "收购日期(月)"
  end

  add_index "dw_acquired_at_dimensions", ["acquired_at"], name: "index_dw_acquired_at_dimensions_on_acquired_at", using: :btree
  add_index "dw_acquired_at_dimensions", ["acquired_at_date"], name: "index_dw_acquired_at_dimensions_on_acquired_at_date", using: :btree
  add_index "dw_acquired_at_dimensions", ["acquired_at_month"], name: "index_dw_acquired_at_dimensions_on_acquired_at_month", using: :btree
  add_index "dw_acquired_at_dimensions", ["acquired_at_year"], name: "index_dw_acquired_at_dimensions_on_acquired_at_year", using: :btree

  create_table "dw_acquisition_facts", force: :cascade, comment: "入库事实" do |t|
    t.integer  "car_id",                                                      comment: "车辆ID"
    t.integer  "car_dimension_id",                                            comment: "车辆维度ID"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "acquisition_price_cents",  limit: 8, default: 0,              comment: "收购价格"
    t.integer  "acquirer_id",                                                 comment: "收购员"
    t.string   "acquisition_type",                                            comment: "收购类型"
    t.integer  "acquired_at_dimension_id",                                    comment: "收购日期纬度"
  end

  add_index "dw_acquisition_facts", ["car_dimension_id"], name: "index_dw_acquisition_facts_on_car_dimension_id", using: :btree
  add_index "dw_acquisition_facts", ["car_id"], name: "index_dw_acquisition_facts_on_car_id", using: :btree

  create_table "dw_car_dimensions", force: :cascade, comment: "车辆维度" do |t|
    t.integer  "car_id",                                                                  comment: "车辆ID"
    t.string   "state",                                                                   comment: "车辆状态"
    t.integer  "show_price_cents",                     limit: 8,                          comment: "展厅价格"
    t.integer  "online_price_cents",                   limit: 8,                          comment: "网络价格"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "prepare_items_total_amount_cents",     limit: 8, default: 0,              comment: "整备费用"
    t.string   "brand_name",                                                              comment: "品牌名称"
    t.string   "series_name",                                                             comment: "车系名称"
    t.integer  "age",                                                                     comment: "车龄"
    t.datetime "deleted_at",                                                              comment: "删除时间"
    t.integer  "stock_age",                                                               comment: "库龄"
    t.integer  "shop_id",                                                                 comment: "分店ID"
    t.integer  "company_id",                                                              comment: "公司ID"
    t.integer  "sale_total_transfer_fee_cents",        limit: 8,                          comment: "销售过户总费用"
    t.integer  "acquisition_total_transfer_fee_cents", limit: 8,                          comment: "收购过户总费用"
    t.integer  "estimated_gross_profit_cents",         limit: 8, default: 0,              comment: "预期毛利"
    t.float    "estimated_gross_profit_rate",                                             comment: "预期毛利率"
  end

  add_index "dw_car_dimensions", ["car_id"], name: "index_dw_car_dimensions_on_car_id", using: :btree

  create_table "dw_out_of_stock_facts", force: :cascade, comment: "出库事实" do |t|
    t.integer  "car_id",                                                           comment: "车辆ID"
    t.integer  "car_dimension_id",                                                 comment: "车辆维度ID"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "stock_out_inventory_id",                                           comment: "出库表ID"
    t.string   "stock_out_inventory_type",                                         comment: "出库类型"
    t.integer  "stock_out_at_dimension_id",                                        comment: "出库时间纬度ID"
    t.string   "mode",                                                             comment: "出库方式"
    t.integer  "seller_id",                                                        comment: "销售员"
    t.integer  "closing_cost_cents",        limit: 8, default: 0,                  comment: "成交价"
    t.integer  "commission_cents",          limit: 8, default: 0,                  comment: "佣金"
    t.integer  "refund_price_cents",        limit: 8, default: 0,                  comment: "退回车价"
    t.boolean  "current",                             default: false,              comment: "当前清单"
    t.integer  "other_fee_cents",           limit: 8, default: 0,                  comment: "其他费用"
    t.integer  "carried_interest_cents",    limit: 8, default: 0,                  comment: "提成金额"
  end

  add_index "dw_out_of_stock_facts", ["car_dimension_id"], name: "index_dw_out_of_stock_facts_on_car_dimension_id", using: :btree
  add_index "dw_out_of_stock_facts", ["car_id"], name: "index_dw_out_of_stock_facts_on_car_id", using: :btree

  create_table "dw_stock_out_at_dimensions", force: :cascade, comment: "出库时间纬度" do |t|
    t.date    "stock_out_at",       comment: "收购时间"
    t.integer "stock_out_at_year",  comment: "收购日期(年)"
    t.integer "stock_out_at_month", comment: "收购日期(月)"
  end

  add_index "dw_stock_out_at_dimensions", ["stock_out_at"], name: "index_dw_stock_out_at_dimensions_on_stock_out_at", using: :btree
  add_index "dw_stock_out_at_dimensions", ["stock_out_at_month"], name: "index_dw_stock_out_at_dimensions_on_stock_out_at_month", using: :btree
  add_index "dw_stock_out_at_dimensions", ["stock_out_at_year"], name: "index_dw_stock_out_at_dimensions_on_stock_out_at_year", using: :btree

  create_table "easy_loan_accredited_record_histories", force: :cascade, comment: "记录授信变更历史" do |t|
    t.integer  "accredited_record_id",                        comment: "对应授信记录"
    t.integer  "limit_amount_cents",   limit: 8,              comment: "变更前的授信金额"
    t.decimal  "single_car_rate",                             comment: "变更前的单车比例"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "easy_loan_accredited_records", force: :cascade, comment: "公司授信记录" do |t|
    t.integer  "company_id",                                             comment: "被授信车商公司id"
    t.integer  "limit_amount_cents",  limit: 8, default: 0,              comment: "额度"
    t.integer  "in_use_amount_cents", limit: 8, default: 0,              comment: "已用额度"
    t.integer  "funder_company_id",                                      comment: "资金方公司id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.decimal  "single_car_rate",                                        comment: "单车借款比例"
    t.integer  "sp_company_id",                                          comment: "对应的sp公司"
  end

  create_table "easy_loan_authority_roles", force: :cascade, comment: "车融易角色权限" do |t|
    t.string   "name",                                                           comment: "权限名称"
    t.text     "note",                                                           comment: "权限说明"
    t.text     "authorities",             default: [],              array: true, comment: "权限清单"
    t.integer  "easy_loan_sp_company_id",                                        comment: "和sp公司关联"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "easy_loan_authority_roles", ["easy_loan_sp_company_id"], name: "index_easy_loan_authority_roles_on_easy_loan_sp_company_id", using: :btree

  create_table "easy_loan_cities", force: :cascade, comment: "车融易地区" do |t|
    t.string   "name",                                 comment: "地区中文名称"
    t.string   "pinyin",                               comment: "地区拼音"
    t.string   "zip_code",                             comment: "地区邮编"
    t.json     "score",      default: {},              comment: "城市综合指数最小／最大／最可能分"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "easy_loan_debits", force: :cascade, comment: "借款方统计信息" do |t|
    t.integer  "inventory_amount",                                 comment: "计算月库存资金量"
    t.decimal  "operating_health",                                 comment: "计算月经营健康评级"
    t.decimal  "industry_rating",       default: 3.0,              comment: "设置借方行业风评"
    t.decimal  "assets_debts_rating",   default: 0.6,              comment: "设置借方资产负债率"
    t.decimal  "comprehensive_rating",                             comment: "计算月综合评级"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "company_id",                                       comment: "统计数据和公司关联"
    t.decimal  "beat_global",                                      comment: "综合评分打败全国车商数据"
    t.decimal  "beat_local",                                       comment: "综合评分打败本地车商数据"
    t.integer  "real_inventory_amount",                            comment: "真实库存资金量数据"
    t.decimal  "cash_turnover_rate",                               comment: "资金周转率"
    t.decimal  "car_gross_profit_rate",                            comment: "月利润率"
  end

  add_index "easy_loan_debits", ["company_id"], name: "index_easy_loan_debits_on_company_id", using: :btree

  create_table "easy_loan_funder_companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "easy_loan_loan_bill_histories", force: :cascade, comment: "借款单状态变更历史" do |t|
    t.integer  "easy_loan_loan_bill_id",                        comment: "对应的借款单"
    t.integer  "user_id",                                       comment: "操作人"
    t.string   "bill_state",                                    comment: "记录当前的状态"
    t.string   "message",                                       comment: "记录时的状态对应的消息"
    t.string   "note",                                          comment: "对应的备注"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "user_type",                                     comment: "用户类型"
    t.integer  "amount_cents",           limit: 8,              comment: "更改状态时记录相应的金额"
  end

  add_index "easy_loan_loan_bill_histories", ["easy_loan_loan_bill_id"], name: "index_easy_loan_loan_bill_histories_on_easy_loan_loan_bill_id", using: :btree
  add_index "easy_loan_loan_bill_histories", ["user_id"], name: "index_easy_loan_loan_bill_histories_on_user_id", using: :btree

  create_table "easy_loan_loan_bills", force: :cascade, comment: "借款单" do |t|
    t.integer  "company_id",                                                      comment: "借款公司"
    t.integer  "car_id",                                                          comment: "用哪辆车进行借款"
    t.integer  "sp_company_id",                                                   comment: "通过哪家sp公司"
    t.integer  "funder_company_id",                                               comment: "提供资金公司"
    t.jsonb    "car_basic_info",                                                  comment: "冗余车辆基本信息"
    t.string   "state",                                                           comment: "借款单当前状态"
    t.jsonb    "state_history",                                                   comment: "状态变更历史记录概要"
    t.string   "apply_code",                                                      comment: "申请编号"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "estimate_borrow_amount_cents", limit: 8, default: 0,              comment: "预计申请借款金额"
    t.integer  "borrowed_amount_cents",        limit: 8, default: 0,              comment: "实际申请借款金额"
  end

  add_index "easy_loan_loan_bills", ["car_id"], name: "index_easy_loan_loan_bills_on_car_id", using: :btree
  add_index "easy_loan_loan_bills", ["company_id"], name: "index_easy_loan_loan_bills_on_company_id", using: :btree

  create_table "easy_loan_messages", force: :cascade, comment: "车融易里的消息" do |t|
    t.integer  "user_id",                                    comment: "对应user"
    t.string   "user_type",                                  comment: "user多态"
    t.integer  "easy_loan_operation_record_id",              comment: "对应的车融易里操作记录"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "easy_loan_operation_records", force: :cascade, comment: "车融易用户操作记录" do |t|
    t.integer  "targetable_id",                      comment: "操作对象"
    t.string   "targetable_type",                    comment: "操作对象"
    t.string   "operation_record_type",              comment: "事件类型"
    t.integer  "user_id",                            comment: "操作人ID"
    t.jsonb    "messages",                           comment: "操作信息"
    t.integer  "sp_company_id",                      comment: "对应所属sp公司"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "user_type",                          comment: "操作人多态"
    t.jsonb    "detail",                             comment: "操作记录详情"
  end

  create_table "easy_loan_rating_statements", force: :cascade, comment: "车融易评级说明" do |t|
    t.integer  "score",                   comment: "分数"
    t.string   "rate_type",               comment: "评级类型"
    t.text     "content",                 comment: "评级说明内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "easy_loan_settings", force: :cascade, comment: "车融易全局数据设置" do |t|
    t.string   "phone",                                        comment: "联系电话"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.decimal  "gross_rake",        default: 0.7,              comment: "（健康评级）毛利润率评级权重"
    t.decimal  "assets_debts_rate", default: 0.3,              comment: "（健康评级）资产负债率评级权重"
    t.decimal  "inventory_amount",  default: 0.2,              comment: "（综合指数）库存资金量权重"
    t.decimal  "operating_health",  default: 0.4,              comment: "（综合指数）经营健康评级权重"
    t.decimal  "industry_rating",   default: 0.4,              comment: "（综合指数）行业风评权重"
  end

  create_table "easy_loan_sp_companies", force: :cascade, comment: "借款的sp公司" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "easy_loan_users", force: :cascade, comment: "车融易用户模型" do |t|
    t.string   "phone",                                                                comment: "手机号码"
    t.string   "token",                                                                comment: "验证码"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "expired_at",                                                           comment: "短信验证码失效时间"
    t.string   "current_device_number",                                                comment: "车融易当前登录设备号码"
    t.string   "name",                                                                 comment: "车融易用户姓名"
    t.integer  "easy_loan_sp_company_id",                                              comment: "所属sp公司"
    t.text     "authorities",                 default: [],                array: true, comment: "权限清单"
    t.text     "city",                                                                 comment: "员工所属地区"
    t.boolean  "status",                      default: true,                           comment: "员工状态"
    t.integer  "easy_loan_authority_role_id",                                          comment: "角色关联"
    t.string   "rc_token",                                                             comment: "融云token"
  end

  add_index "easy_loan_users", ["easy_loan_authority_role_id"], name: "index_easy_loan_users_on_easy_loan_authority_role_id", using: :btree

  create_table "expiration_notifications", force: :cascade, comment: "服务到期提醒" do |t|
    t.string   "notify_type",                                 comment: "通知类型"
    t.integer  "associated_id",                               comment: "关联记录ID"
    t.string   "associated_type",                             comment: "关联记录类型"
    t.date     "notify_date",                                 comment: "提醒日期"
    t.date     "setting_date",                                comment: "原记录里设置的时间"
    t.integer  "user_id",                                     comment: "要通知到的用户"
    t.integer  "company_id",                                  comment: "所属公司ID"
    t.boolean  "actived",         default: true,              comment: "是否可用"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "notify_name",                                 comment: "通知的名字"
  end

  create_table "expiration_settings", force: :cascade, comment: "公司设置到期提醒时间" do |t|
    t.integer  "company_id",                 comment: "所属公司"
    t.string   "notify_type",                comment: "提醒类型"
    t.integer  "first_notify",               comment: "首次提醒时间"
    t.integer  "second_notify",              comment: "再次提醒时间"
    t.integer  "third_notify",               comment: "三次提醒时间"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "expiration_settings", ["company_id"], name: "index_expiration_settings_on_company_id", using: :btree

  create_table "feedbacks", force: :cascade, comment: "用户反馈" do |t|
    t.string   "note",                    comment: "反馈内容"
    t.integer  "user_id",                 comment: "用户ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "finance_car_fees", force: :cascade, comment: "车辆费用" do |t|
    t.integer  "car_id",                              comment: "关联车辆"
    t.integer  "creator_id",                          comment: "项目创建者"
    t.string   "category",                            comment: "所属项目分类"
    t.string   "item_name",                           comment: "具体项目名"
    t.integer  "amount_cents", limit: 8,              comment: "费用数额"
    t.date     "fee_date",                            comment: "费用日期"
    t.text     "note",                                comment: "说明"
    t.integer  "user_id",                             comment: "关联用户"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "finance_car_fees", ["car_id"], name: "index_finance_car_fees_on_car_id", using: :btree
  add_index "finance_car_fees", ["creator_id"], name: "index_finance_car_fees_on_creator_id", using: :btree

  create_table "finance_car_incomes", force: :cascade, comment: "财务管理-单车成本和收益" do |t|
    t.integer  "car_id",                                         comment: "关联车辆"
    t.integer  "company_id",                                     comment: "所属公司"
    t.integer  "payment_cents",           limit: 8,              comment: "入库付款"
    t.integer  "prepare_cost_cents",      limit: 8,              comment: "整备费用"
    t.integer  "handling_charge_cents",   limit: 8,              comment: "手续费"
    t.integer  "commission_cents",        limit: 8,              comment: "佣金"
    t.integer  "percentage_cents",        limit: 8,              comment: "提成/分成"
    t.integer  "fund_cost_cents",         limit: 8,              comment: "资金成本"
    t.integer  "other_cost_cents",        limit: 8,              comment: "其他成本"
    t.integer  "receipt_cents",           limit: 8,              comment: "出库收款"
    t.integer  "other_profit_cents",      limit: 8,              comment: "其他收益"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "acquisition_price_cents", limit: 8,              comment: "收购价格"
    t.integer  "closing_cost_cents",      limit: 8,              comment: "成交价格"
    t.decimal  "fund_rate",                                      comment: "单车对应的资金利率"
    t.integer  "loan_cents",              limit: 8,              comment: "单车融资数额"
  end

  add_index "finance_car_incomes", ["car_id"], name: "index_finance_car_incomes_on_car_id", using: :btree
  add_index "finance_car_incomes", ["company_id"], name: "index_finance_car_incomes_on_company_id", using: :btree

  create_table "finance_shop_fees", force: :cascade, comment: "单店运营运营成本和收益" do |t|
    t.integer  "shop_id",                               comment: "关联分店"
    t.string   "month",                                 comment: "年月"
    t.integer  "location_rent_cents",                   comment: "场地租金"
    t.integer  "salary_cents",                          comment: "固定工资"
    t.integer  "social_insurance_cents",                comment: "社保／公积金"
    t.integer  "bonus_cents",                           comment: "奖金／福利"
    t.integer  "marketing_expenses_cents",              comment: "市场营销"
    t.integer  "energy_fee_cents",                      comment: "水电"
    t.integer  "office_fee_cents",                      comment: "办公用品"
    t.integer  "communication_fee_cents",               comment: "通讯费"
    t.integer  "other_cost_cents",                      comment: "其它支出"
    t.integer  "other_profit_cents",                    comment: "其它收入"
    t.text     "note",                                  comment: "备注"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "finance_shop_fees", ["shop_id"], name: "index_finance_shop_fees_on_shop_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id",                                comment: "多态ID"
    t.string   "imageable_type",                              comment: "多态名"
    t.string   "url",                                         comment: "图片URL"
    t.string   "name",                                        comment: "名称"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "location",                                    comment: "图片位置"
    t.boolean  "is_cover",       default: false,              comment: "是否为LOGO"
    t.integer  "sort",           default: 0,                  comment: "排序"
    t.string   "image_style",                                 comment: "图片的类型"
  end

  add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

  create_table "import_tasks", force: :cascade, comment: "意向导入记录" do |t|
    t.integer  "user_id",                                           comment: "操作人"
    t.string   "state",            default: "pending",              comment: "状态"
    t.string   "import_task_type",                                  comment: "记录类型"
    t.jsonb    "info",             default: {},                     comment: "相关信息"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "company_id",                                        comment: "公司ID"
  end

  add_index "import_tasks", ["user_id"], name: "index_import_tasks_on_user_id", using: :btree

  create_table "insurance_companies", force: :cascade, comment: "保险公司" do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.string   "name",                    comment: "名称"
    t.datetime "deleted_at",              comment: "删除时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "insurance_companies", ["company_id"], name: "index_insurance_companies_on_company_id", using: :btree

  create_table "intention_appointment_cars", force: :cascade, comment: "预约看车" do |t|
    t.datetime "appointment_time",              comment: "预约时间"
    t.integer  "company_id",                    comment: "归属车商"
    t.integer  "car_id",                        comment: "预约车辆"
    t.integer  "intention_id",                  comment: "关系的意向"
    t.text     "description",                   comment: "预约说明"
    t.text     "note",                          comment: "备注"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "intention_appointment_cars", ["car_id"], name: "index_intention_appointment_cars_on_car_id", using: :btree
  add_index "intention_appointment_cars", ["intention_id"], name: "index_intention_appointment_cars_on_intention_id", using: :btree

  create_table "intention_expirations", force: :cascade, comment: "意向过期时间" do |t|
    t.integer  "company_id",                 comment: "公司ID"
    t.integer  "recovery_time", null: false, comment: "过期天数"
    t.text     "note",                       comment: "备注"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "recovery_hour",              comment: "过期小时"
  end

  add_index "intention_expirations", ["company_id"], name: "index_intention_expirations_on_company_id", using: :btree

  create_table "intention_levels", force: :cascade, comment: "意向级别" do |t|
    t.integer  "company_id",                                       comment: "公司ID"
    t.string   "name",                                             comment: "名称"
    t.string   "note",                                             comment: "说明"
    t.datetime "deleted_at",                                       comment: "删除时间"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "time_limitation", default: 0,                      comment: "时间限制"
    t.string   "company_type",    default: "Company"
  end

  add_index "intention_levels", ["company_id"], name: "index_intention_levels_on_company_id", using: :btree
  add_index "intention_levels", ["name"], name: "index_intention_levels_on_name", using: :btree

  create_table "intention_push_cars", force: :cascade, comment: "看过的车辆" do |t|
    t.integer  "intention_id",                           comment: "意向ID"
    t.integer  "intention_push_history_id",              comment: "意向跟进历史ID"
    t.integer  "car_id",                                 comment: "车辆ID"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "intention_push_cars", ["car_id"], name: "index_intention_push_cars_on_car_id", using: :btree
  add_index "intention_push_cars", ["intention_id"], name: "index_intention_push_cars_on_intention_id", using: :btree
  add_index "intention_push_cars", ["intention_push_history_id"], name: "intention_follow_up_cars_history_id", using: :btree

  create_table "intention_push_fail_reasons", force: :cascade, comment: "意向跟进失败原因" do |t|
    t.integer  "company_id",              comment: "公司id"
    t.text     "note",                    comment: "备注"
    t.string   "name",                    comment: "失败原因名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "intention_push_histories", force: :cascade, comment: "意向跟进历史" do |t|
    t.integer  "intention_id",                                                         comment: "意向ID"
    t.string   "state",                                                                comment: "跟进状态/结果"
    t.boolean  "checked",                                 default: false,              comment: "是否到店/是否评估实车"
    t.text     "note",                                                                 comment: "说明"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "estimated_price_cents",         limit: 8,                              comment: "评估车价"
    t.datetime "interviewed_time",                                                     comment: "预约时间"
    t.datetime "processing_time",                                                      comment: "跟进时间"
    t.integer  "intention_level_id",                                                   comment: "意向等级ID"
    t.integer  "checked_count",                                                        comment: "到店/评估次数"
    t.integer  "executor_id",                                                          comment: "执行人"
    t.integer  "deposit_cents",                 limit: 8,                              comment: "定金"
    t.integer  "closing_cost_cents",            limit: 8,                              comment: "成交价格"
    t.integer  "closing_car_id",                limit: 8,                              comment: "成交车辆ID"
    t.string   "closing_car_name",                                                     comment: "成交车辆名称"
    t.string   "type",                                                                 comment: "STI"
    t.integer  "intention_push_fail_reason_id",                                        comment: "战败原因ID"
  end

  add_index "intention_push_histories", ["intention_id"], name: "index_intention_push_histories_on_intention_id", using: :btree

  create_table "intention_shared_users", force: :cascade, comment: "意向共享用户中间表" do |t|
    t.integer  "intention_id",              comment: "关联的意向"
    t.integer  "user_id",                   comment: "分享给的用户"
    t.integer  "customer_id",               comment: "客户ID"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "intention_shared_users", ["intention_id"], name: "index_intention_shared_users_on_intention_id", using: :btree
  add_index "intention_shared_users", ["user_id"], name: "index_intention_shared_users_on_user_id", using: :btree

  create_table "intentions", force: :cascade, comment: "意向" do |t|
    t.integer  "customer_id",                                                                                  comment: "客户ID"
    t.string   "customer_name",                                                                                comment: "客户姓名"
    t.string   "intention_type",                                                                               comment: "意向类型"
    t.integer  "creator_id",                                                                                   comment: "意向创建者"
    t.integer  "assignee_id",                                                                                  comment: "分配员工ID"
    t.string   "province",                                                                                     comment: "省份"
    t.string   "city",                                                                                         comment: "城市"
    t.integer  "intention_level_id",                                                                           comment: "意向级别ID"
    t.integer  "channel_id",                                                                                   comment: "客户渠道"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.integer  "company_id",                                                                                   comment: "公司ID"
    t.integer  "shop_id",                                                                                      comment: "店ID"
    t.string   "customer_phones",                         default: [],                            array: true, comment: "客户联系方式"
    t.string   "state",                                   default: "pending",                                  comment: "跟进状态"
    t.string   "customer_phone",                                                                               comment: "客户电话"
    t.text     "intention_note",                                                                               comment: "意向描述"
    t.string   "gender",                                                                                       comment: "性别"
    t.string   "brand_name",                                                                                   comment: "出售车辆品牌名称"
    t.string   "series_name",                                                                                  comment: "出售车辆车系名称"
    t.string   "color",                                                                                        comment: "颜色"
    t.float    "mileage",                                                                                      comment: "里程(万公里)"
    t.date     "licensed_at",                                                                                  comment: "上牌日期"
    t.integer  "minimum_price_cents",           limit: 8,                                                      comment: "最低价格"
    t.integer  "maximum_price_cents",           limit: 8,                                                      comment: "最高价格"
    t.integer  "estimated_price_cents",         limit: 8,                                                      comment: "评估车价"
    t.jsonb    "seeking_cars",                            default: [],                            array: true, comment: "求购车辆"
    t.string   "style_name",                                                                                   comment: "出售车辆车款名称"
    t.datetime "interviewed_time",                                                                             comment: "预约时间"
    t.datetime "processing_time",                                                                              comment: "跟进时间"
    t.integer  "checked_count",                           default: 0,                                          comment: "到店/评估次数"
    t.date     "consigned_at",                                                                                 comment: "寄卖时间"
    t.datetime "deleted_at",                                                                                   comment: "删除时间"
    t.string   "source",                                  default: "user_operation",                           comment: "意向产生来源"
    t.integer  "import_task_id",                                                                               comment: "意向导入记录ID"
    t.integer  "source_car_id",                                                                                comment: "来源车辆ID"
    t.integer  "source_company_id",                                                                            comment: "来源公司ID"
    t.integer  "deposit_cents",                 limit: 8,                                                      comment: "定金"
    t.integer  "closing_cost_cents",            limit: 8,                                                      comment: "成交价格"
    t.integer  "closing_car_id",                limit: 8,                                                      comment: "成交车辆ID"
    t.string   "closing_car_name",                                                                             comment: "成交车辆名称"
    t.string   "creator_type",                                                                                 comment: "意向创建者多态"
    t.integer  "alliance_company_id"
    t.integer  "alliance_assignee_id",                                                                         comment: "联盟用户ID"
    t.boolean  "earnest",                                 default: false,                                      comment: "是否已收意向金"
    t.datetime "alliance_assigned_at",                                                                         comment: "分配给车商的时间"
    t.datetime "in_shop_at",                                                                                   comment: "客户到店时间"
    t.string   "alliance_state",                                                                               comment: "联盟意向状态"
    t.integer  "alliance_intention_level_id"
    t.date     "annual_inspection_notify_date",                                                                comment: "年审到期提醒日期"
    t.date     "insurance_notify_date",                                                                        comment: "保险到期提醒日期"
    t.date     "mortgage_notify_date",                                                                         comment: "按揭到期提醒日期"
    t.integer  "after_sale_assignee_id",                                                                       comment: "服务归属人ID"
  end

  add_index "intentions", ["alliance_assignee_id"], name: "index_intentions_on_alliance_assignee_id", using: :btree
  add_index "intentions", ["alliance_company_id"], name: "index_intentions_on_alliance_company_id", using: :btree
  add_index "intentions", ["assignee_id"], name: "index_intentions_on_assignee_id", using: :btree
  add_index "intentions", ["channel_id"], name: "index_intentions_on_channel_id", using: :btree
  add_index "intentions", ["created_at"], name: "index_intentions_on_created_at", using: :btree
  add_index "intentions", ["creator_id"], name: "index_intentions_on_creator_id", using: :btree
  add_index "intentions", ["customer_id"], name: "index_intentions_on_customer_id", using: :btree
  add_index "intentions", ["intention_level_id"], name: "index_intentions_on_intention_level_id", using: :btree
  add_index "intentions", ["intention_type"], name: "index_intentions_on_intention_type", using: :btree
  add_index "intentions", ["interviewed_time"], name: "index_intentions_on_interviewed_time", using: :btree
  add_index "intentions", ["processing_time"], name: "index_intentions_on_processing_time", using: :btree
  add_index "intentions", ["state"], name: "index_intentions_on_state", using: :btree

  create_table "login_histories", force: :cascade do |t|
    t.integer  "user_id",                    comment: "用户ID"
    t.integer  "company_id",                 comment: "公司ID"
    t.string   "ip",                         comment: "IP地址"
    t.string   "user_agent",                 comment: "UserAgent"
    t.string   "mac_address",                comment: "MAC地址"
    t.string   "device_number",              comment: "APP设备号"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "login_histories", ["company_id"], name: "index_login_histories_on_company_id", using: :btree
  add_index "login_histories", ["user_id"], name: "index_login_histories_on_user_id", using: :btree

  create_table "maintenance_record_hubs", force: :cascade, comment: "维保中心" do |t|
    t.string   "vin"
    t.string   "brand",                                     comment: "品牌"
    t.string   "style_name",                                comment: "车系"
    t.string   "transmission",                              comment: "变速器"
    t.string   "displacement",                              comment: "排气量"
    t.string   "origin",                                    comment: "来源"
    t.datetime "report_at",                                 comment: "报告时间"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.json     "items",           default: [],              comment: "详细报告"
    t.string   "order_id",                     null: false, comment: "订单ID"
    t.integer  "order_status",                              comment: "维保查询结果状态"
    t.string   "order_message",                             comment: "维保查询结果"
    t.integer  "notify_status",                             comment: "异步回调结果状态"
    t.string   "notify_message",                            comment: "异步回调结果消息"
    t.jsonb    "abstract_items",                            comment: "报告概要项目"
    t.datetime "request_sent_at",                           comment: "发送给车鉴定的请求时间"
  end

  add_index "maintenance_record_hubs", ["order_id"], name: "index_maintenance_record_hubs_on_order_id", using: :btree
  add_index "maintenance_record_hubs", ["vin"], name: "index_maintenance_record_hubs_on_vin", using: :btree

  create_table "maintenance_records", force: :cascade, comment: "维保记录" do |t|
    t.integer  "company_id",                                                          comment: "公司ID"
    t.integer  "car_id",                                                              comment: "车辆ID"
    t.string   "vin"
    t.string   "state"
    t.integer  "last_fetch_by",                                                       comment: "最后查询的用户ID"
    t.string   "user_name",                                                           comment: "最后查询的用户名"
    t.datetime "last_fetch_at",                                                       comment: "最后查询的时间"
    t.integer  "maintenance_record_hub_id"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "engine",                                                              comment: "发动机"
    t.string   "license_plate",                                                       comment: "车牌"
    t.integer  "last_maintenance_record_hub_id"
    t.integer  "shop_id"
    t.decimal  "token_price",                    precision: 8, scale: 2
    t.decimal  "pre_token_price",                precision: 8, scale: 2
    t.string   "vin_image",                                                           comment: "vin码图片地址"
    t.string   "token_type",                                                          comment: "支付token的类型"
    t.integer  "token_id",                                                            comment: "支付token"
  end

  add_index "maintenance_records", ["car_id"], name: "index_maintenance_records_on_car_id", using: :btree
  add_index "maintenance_records", ["company_id"], name: "index_maintenance_records_on_company_id", using: :btree
  add_index "maintenance_records", ["maintenance_record_hub_id"], name: "index_maintenance_records_on_maintenance_record_hub_id", using: :btree
  add_index "maintenance_records", ["vin"], name: "index_maintenance_records_on_vin", using: :btree

  create_table "maintenance_settings", force: :cascade do |t|
    t.decimal "chejianding_unit_price",  precision: 8, scale: 2, default: 17.0
    t.decimal "ant_queen_unit_price",    precision: 8, scale: 2, default: 29.0
    t.decimal "cha_doctor_unit_price",   precision: 8, scale: 2, default: 12.0
    t.decimal "dashenglaile_unit_price", precision: 8, scale: 2, default: 12.0
  end

  create_table "messages", force: :cascade, comment: "消息" do |t|
    t.integer  "user_id",                                          comment: "用户ID"
    t.integer  "operation_record_id",                              comment: "操作历史ID"
    t.boolean  "read",                default: false,              comment: "是否已读"
    t.datetime "read_at",                                          comment: "阅读时间"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "user_type"
  end

  add_index "messages", ["operation_record_id"], name: "index_messages_on_operation_record_id", using: :btree
  add_index "messages", ["read"], name: "index_messages_on_read", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "mortgage_companies", force: :cascade, comment: "按揭公司" do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.string   "name",                    comment: "名称"
    t.datetime "deleted_at",              comment: "删除时间"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mortgage_companies", ["company_id"], name: "index_mortgage_companies_on_company_id", using: :btree

  create_table "old_driver_record_hubs", force: :cascade, comment: "老司机报告内容" do |t|
    t.string   "vin",                      comment: "vin码"
    t.string   "order_id",                 comment: "对方订单ID"
    t.string   "engine_num",               comment: "发动机号"
    t.string   "license_no",               comment: "车牌号"
    t.string   "id_numbers",               comment: "身份证号，以逗号分隔"
    t.datetime "sent_at",                  comment: "发送时间"
    t.datetime "notify_at",                comment: "回调通知时间"
    t.string   "make",                     comment: "车型信息"
    t.jsonb    "insurance",                comment: "保险区间"
    t.jsonb    "claims",                   comment: "事故"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "meter_error",              comment: "里程表是否异常"
    t.string   "smoke_level",              comment: "排放标准"
    t.string   "year",                     comment: "生产年份"
    t.string   "nature",                   comment: "车辆性质"
  end

  create_table "old_driver_records", force: :cascade, comment: "老司机查询记录" do |t|
    t.integer  "user_id",                               comment: "查询的用户"
    t.string   "user_name",                             comment: "查询用户名"
    t.integer  "company_id",                            comment: "所属公司"
    t.integer  "shop_id",                               comment: "所属shop"
    t.string   "order_id",                              comment: "返回的订单ID"
    t.string   "state",                                 comment: "本记录状态"
    t.string   "payment_state"
    t.string   "action_type"
    t.decimal  "token_price",                           comment: "花费的车币"
    t.integer  "token_id",                              comment: "扣费的token"
    t.string   "token_type",                            comment: "扣费的token类型"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "old_driver_record_hub_id",              comment: "关联的hub"
    t.string   "vin",                                   comment: "vin码"
    t.integer  "car_id",                                comment: "车辆ID"
    t.integer  "before_update_hub_id",                  comment: "更新前的报告id"
  end

  add_index "old_driver_records", ["company_id"], name: "index_old_driver_records_on_company_id", using: :btree
  add_index "old_driver_records", ["user_id"], name: "index_old_driver_records_on_user_id", using: :btree

  create_table "online_estimations", force: :cascade, comment: "在线评估" do |t|
    t.string   "brand_name",                  comment: "品牌"
    t.string   "series_name",                 comment: "车系"
    t.string   "style_name",                  comment: "车型"
    t.string   "licensed_at",                 comment: "上牌日期"
    t.float    "mileage",                     comment: "表显里程(万公里)"
    t.string   "customer_phone",              comment: "手机号码"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "operation_records", force: :cascade, comment: "操作历史" do |t|
    t.integer  "targetable_id",                                       comment: "多态ID"
    t.string   "targetable_type",                                     comment: "多态类型"
    t.string   "operation_record_type",                               comment: "事件类型"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "user_id",                                             comment: "操作人ID"
    t.jsonb    "messages",              default: {},                  comment: "操作信息"
    t.integer  "company_id",                                          comment: "公司ID"
    t.integer  "shop_id",                                             comment: "店ID"
    t.jsonb    "detail",                default: {},                  comment: "详情"
    t.string   "user_type",             default: "User"
    t.jsonb    "user_passport",         default: {},                  comment: "操作用户信息"
  end

  add_index "operation_records", ["created_at"], name: "index_operation_records_on_created_at", using: :btree
  add_index "operation_records", ["operation_record_type", "created_at"], name: "index_operation_records_on_operation_record_type_and_created_at", using: :btree
  add_index "operation_records", ["targetable_id", "targetable_type"], name: "index_operation_records_on_targetable_id_and_targetable_type", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "channel"
    t.integer  "amount_cents"
    t.string   "currency"
    t.string   "client_ip"
    t.string   "status"
    t.integer  "orderable_id"
    t.string   "orderable_type"
    t.integer  "quantity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "charge_id",                   comment: "ChargeID，由pingpp返回"
    t.string   "action",                      comment: "订单类别"
    t.integer  "shop_id"
    t.string   "token_type",                  comment: "标记个人或公司的车币"
  end

  create_table "owner_companies", force: :cascade, comment: "归属车商" do |t|
    t.string   "name",                    comment: "车商名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "shop_id",                 comment: "车商所属的分店"
    t.integer  "company_id",              comment: "所属车商"
  end

  create_table "parallel_brands", force: :cascade, comment: "平行进口车和厂家特价车的品牌" do |t|
    t.string   "name",                                  comment: "品牌名称"
    t.string   "logo_url",                              comment: "LOGO 图片 URL"
    t.integer  "order",                                 comment: "排序"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "brand_type",                            comment: "品牌类型(平行进口车/厂家特价车)"
    t.integer  "styles_count", default: 0,              comment: "车型数量"
  end

  create_table "parallel_phones", force: :cascade, comment: "平行进口车客服电话" do |t|
    t.string   "number",                  comment: "电话号码"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parallel_styles", force: :cascade, comment: "平行进口车和厂家特价车的车型" do |t|
    t.string   "name",                                                     comment: "车型名称"
    t.string   "origin",                                                   comment: "原产地"
    t.string   "color",                                                    comment: "颜色"
    t.text     "configuration",                                            comment: "配置信息"
    t.string   "status",                                                   comment: "状态(现车, 报关中, etc)"
    t.integer  "suggested_price_cents", limit: 8,                          comment: "同款新车指导价"
    t.integer  "sell_price_cents",      limit: 8,                          comment: "港口自提价/销售成交价"
    t.string   "style_type",                                               comment: "平行进口车/厂家特价车"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "parallel_brand_id",                                        comment: "品牌"
    t.integer  "images_count",                    default: 0,              comment: "图片数量"
  end

  add_index "parallel_styles", ["parallel_brand_id"], name: "index_parallel_styles_on_parallel_brand_id", using: :btree

  create_table "platform_brands", force: :cascade do |t|
    t.integer  "platform_code"
    t.string   "brand_name"
    t.string   "brand_code"
    t.integer  "price",              limit: 8
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "need_engine_number"
    t.string   "mode"
    t.string   "comment"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "status",                       default: false
  end

  create_table "platform_profiles", force: :cascade do |t|
    t.integer  "company_id",              comment: "公司ID"
    t.jsonb    "data",                    comment: "账号信息"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prepare_items", force: :cascade, comment: "整备项目" do |t|
    t.string   "name",                                     comment: "项目名"
    t.integer  "amount_cents",      limit: 8,              comment: "费用"
    t.integer  "prepare_record_id",                        comment: "整备记录ID"
    t.text     "note",                                     comment: "备注"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "prepare_items", ["prepare_record_id"], name: "index_prepare_items_on_prepare_record_id", using: :btree

  create_table "prepare_records", force: :cascade, comment: "整备管理记录" do |t|
    t.integer  "car_id",                                        comment: "车辆ID"
    t.string   "state",                                         comment: "整备状态"
    t.integer  "total_amount_cents",     limit: 8,              comment: "费用合计"
    t.date     "start_at",                                      comment: "开始时间"
    t.date     "end_at",                                        comment: "结束时间"
    t.string   "repair_state",                                  comment: "维修现状"
    t.text     "note",                                          comment: "补充说明"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "preparer_id",                                   comment: "整备员ID"
    t.integer  "shop_id",                                       comment: "分店ID"
    t.date     "estimated_completed_at",                        comment: "预计完成时间"
  end

  add_index "prepare_records", ["car_id"], name: "index_prepare_records_on_car_id", using: :btree
  add_index "prepare_records", ["preparer_id"], name: "index_prepare_records_on_preparer_id", using: :btree
  add_index "prepare_records", ["state"], name: "index_prepare_records_on_state", using: :btree

  create_table "price_tag_templates", force: :cascade, comment: "价签模板" do |t|
    t.integer  "company_id",                             comment: "公司ID"
    t.string   "name",                                   comment: "模板名称"
    t.text     "code",                                   comment: "模板代码"
    t.string   "backup",                                 comment: "备份地址"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "current",    default: true,              comment: "是否当前模板"
    t.text     "note",                                   comment: "说明"
  end

  add_index "price_tag_templates", ["company_id"], name: "index_price_tag_templates_on_company_id", using: :btree

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["name"], name: "index_provinces_on_name", using: :btree
  add_index "provinces", ["pinyin"], name: "index_provinces_on_pinyin", using: :btree
  add_index "provinces", ["pinyin_abbr"], name: "index_provinces_on_pinyin_abbr", using: :btree

  create_table "public_praise_records", force: :cascade, comment: "二手车之家口碑记录" do |t|
    t.integer  "sumup_id"
    t.string   "link",                         comment: "抓取链接"
    t.string   "level",                        comment: "级别"
    t.string   "most_satisfied",               comment: "最满意的"
    t.string   "least_satisfied",              comment: "最不满意的"
    t.string   "logo",                         comment: "用户Logo"
    t.string   "username",                     comment: "用户名"
    t.jsonb    "content",                      comment: "内容"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "support_count",                comment: "支持数"
    t.integer  "viewed_count",                 comment: "浏览数"
  end

  add_index "public_praise_records", ["level"], name: "index_public_praise_records_on_level", using: :btree
  add_index "public_praise_records", ["link"], name: "index_public_praise_records_on_link", using: :btree
  add_index "public_praise_records", ["sumup_id"], name: "index_public_praise_records_on_sumup_id", using: :btree
  add_index "public_praise_records", ["support_count", "viewed_count"], name: "index_public_praise_records_on_support_count_and_viewed_count", using: :btree

  create_table "public_praise_sumups", force: :cascade, comment: "二手车之家口碑总结" do |t|
    t.string   "brand_name",                                                comment: "品牌"
    t.string   "series_name",                                               comment: "车系"
    t.string   "style_name",                                                comment: "车型"
    t.integer  "brand_id",                                                  comment: "品牌ID"
    t.integer  "series_id",                                                 comment: "车系ID"
    t.integer  "style_id",                                                  comment: "车型ID"
    t.jsonb    "sumup",                                                     comment: "总结评价"
    t.string   "quality_problems",                             array: true, comment: "百车故障"
    t.string   "latest_exist_links", default: [],              array: true, comment: "上一次口碑链接"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "public_praise_sumups", ["brand_id", "series_id", "style_id"], name: "public_praise_sumups_brand_series_style", using: :btree
  add_index "public_praise_sumups", ["style_id"], name: "index_public_praise_sumups_on_style_id", using: :btree
  add_index "public_praise_sumups", ["style_name"], name: "index_public_praise_sumups_on_style_name", using: :btree

  create_table "publisher_profiles", force: :cascade, comment: "发布者信息" do |t|
    t.integer  "company_id",                           comment: "公司ID"
    t.string   "type",                                 comment: "单表继承类型"
    t.jsonb    "data",       default: {},              comment: "账号信息"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "publisher_profiles", ["company_id"], name: "index_publisher_profiles_on_company_id", using: :btree

  create_table "refund_inventories", force: :cascade, comment: "回库清单" do |t|
    t.integer  "car_id",                                                        comment: "车辆ID"
    t.string   "refund_inventory_type",                                         comment: "回库类型"
    t.datetime "refunded_at",                                                   comment: "回库日期"
    t.integer  "refund_price_cents",      limit: 8,                             comment: "退款金额"
    t.integer  "acquisition_price_cents", limit: 8,                             comment: "收购价格"
    t.text     "note",                                                          comment: "描述"
    t.boolean  "current",                           default: true,              comment: "是否为当前回库清单"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "refund_inventories", ["car_id"], name: "index_refund_inventories_on_car_id", using: :btree
  add_index "refund_inventories", ["current"], name: "index_refund_inventories_on_current", using: :btree

  create_table "sale_intentions", force: :cascade, comment: "卖车意向" do |t|
    t.string   "brand_name",                                  comment: "品牌"
    t.string   "series_name",                                 comment: "车系"
    t.string   "style_name",                                  comment: "车款"
    t.integer  "mileage",                                     comment: "里程"
    t.date     "licensed_at",                                 comment: "上牌日期"
    t.string   "phone",                                       comment: "联系电话"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "province",                                    comment: "省"
    t.string   "city",                                        comment: "城市"
    t.integer  "expected_price_cents", limit: 8,              comment: "期望价格"
  end

  create_table "service_appointments", force: :cascade, comment: "服务预约" do |t|
    t.integer  "company_id",                                                comment: "公司ID"
    t.string   "service_appointment_type",                                  comment: "预约类型"
    t.string   "customer_name",                                             comment: "客户姓名"
    t.string   "customer_phone",                                            comment: "客户电话"
    t.string   "state",                    default: "pending",              comment: "状态"
    t.text     "note",                                                      comment: "其他说明"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "service_appointments", ["company_id"], name: "index_service_appointments_on_company_id", using: :btree
  add_index "service_appointments", ["service_appointment_type"], name: "index_service_appointments_on_service_appointment_type", using: :btree
  add_index "service_appointments", ["state"], name: "index_service_appointments_on_state", using: :btree

  create_table "shops", force: :cascade, comment: "店" do |t|
    t.string   "name",                    comment: "名称"
    t.integer  "company_id",              comment: "所属公司"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at",              comment: "伪删除时间"
    t.string   "address",                 comment: "地址"
    t.string   "phone",                   comment: "联系电话"
    t.string   "province",                comment: "所在省份"
    t.string   "city",                    comment: "所在城市"
  end

  add_index "shops", ["company_id"], name: "index_shops_on_company_id", using: :btree

  create_table "shortened_urls", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 20
    t.text     "url",                               null: false
    t.string   "unique_key", limit: 10,             null: false
    t.integer  "use_count",             default: 0, null: false
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortened_urls", ["owner_id", "owner_type"], name: "index_shortened_urls_on_owner_id_and_owner_type", using: :btree
  add_index "shortened_urls", ["unique_key"], name: "index_shortened_urls_on_unique_key", unique: true, using: :btree
  add_index "shortened_urls", ["url"], name: "index_shortened_urls_on_url", using: :btree

  create_table "stock_out_inventories", force: :cascade, comment: "出库清单" do |t|
    t.integer  "car_id",                                                comment: "所属车辆"
    t.string   "stock_out_inventory_type",                              comment: "出库类型"
    t.date     "completed_at",                                          comment: "成交日期"
    t.integer  "seller_id",                                             comment: "成交员工"
    t.integer  "customer_channel_id",                                   comment: "客户来源"
    t.integer  "closing_cost_cents",             limit: 8,              comment: "成交价格"
    t.string   "sales_type",                                            comment: "销售类型"
    t.string   "payment_type",                                          comment: "付款类型"
    t.integer  "deposit_cents",                  limit: 8,              comment: "定金"
    t.integer  "remaining_money_cents",          limit: 8,              comment: "余款"
    t.integer  "transfer_fee_cents",             limit: 8,              comment: "过户费用"
    t.integer  "commission_cents",               limit: 8,              comment: "佣金"
    t.integer  "other_fee_cents",                limit: 8,              comment: "其他费用"
    t.string   "customer_location_province",                            comment: "客户归属地省"
    t.string   "customer_location_city",                                comment: "客户归属地市"
    t.string   "customer_location_address",                             comment: "客户归属地地址"
    t.string   "customer_name",                                         comment: "客户姓名"
    t.string   "customer_phone",                                        comment: "联系电话"
    t.string   "customer_idcard",                                       comment: "证件号"
    t.boolean  "proxy_insurance",                                       comment: "代办保险"
    t.integer  "insurance_company_id",                                  comment: "保险公司"
    t.integer  "commercial_insurance_fee_cents", limit: 8,              comment: "商业险"
    t.integer  "compulsory_insurance_fee_cents", limit: 8,              comment: "交强险"
    t.integer  "mortgage_company_id",                                   comment: "按揭公司"
    t.integer  "down_payment_cents",             limit: 8,              comment: "首付款"
    t.integer  "loan_amount_cents",              limit: 8,              comment: "贷款额度"
    t.integer  "mortgage_period_months",                                comment: "按揭周期(月)"
    t.integer  "mortgage_fee_cents",             limit: 8,              comment: "按揭费用"
    t.integer  "foregift_cents",                 limit: 8,              comment: "押金"
    t.text     "note",                                                  comment: "备注"
    t.date     "refunded_at",                                           comment: "退车日期"
    t.integer  "refund_price_cents",             limit: 8,              comment: "退回车价"
    t.datetime "driven_back_at",                                        comment: "车主开回时间"
    t.datetime "returned_at",                                           comment: "车主归还时间"
    t.boolean  "current",                                               comment: "是否是当前库存状态的清单"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "operator_id"
    t.integer  "shop_id",                                               comment: "分店ID"
    t.integer  "customer_id",                                           comment: "客户ID"
    t.integer  "total_transfer_fee_cents",       limit: 8,              comment: "过户总费用"
    t.integer  "carried_interest_cents",         limit: 8,              comment: "提成金额"
    t.integer  "invoice_fee_cents",              limit: 8,              comment: "发票费用"
  end

  add_index "stock_out_inventories", ["car_id", "current", "stock_out_inventory_type"], name: "stock_out_inventories_car_id_current_type", using: :btree
  add_index "stock_out_inventories", ["customer_channel_id"], name: "index_stock_out_inventories_on_customer_channel_id", using: :btree
  add_index "stock_out_inventories", ["insurance_company_id"], name: "index_stock_out_inventories_on_insurance_company_id", using: :btree
  add_index "stock_out_inventories", ["mortgage_company_id"], name: "index_stock_out_inventories_on_mortgage_company_id", using: :btree
  add_index "stock_out_inventories", ["returned_at"], name: "index_stock_out_inventories_on_returned_at", using: :btree
  add_index "stock_out_inventories", ["sales_type"], name: "index_stock_out_inventories_on_sales_type", using: :btree
  add_index "stock_out_inventories", ["seller_id"], name: "index_stock_out_inventories_on_seller_id", using: :btree

  create_table "task_statistics", force: :cascade, comment: "任务统计" do |t|
    t.integer  "user_id",                                                 comment: "用户ID"
    t.integer  "shop_id",                                                 comment: "分店ID"
    t.integer  "company_id",                                              comment: "公司ID"
    t.date     "record_date",                                             comment: "记录日期"
    t.integer  "intention_interviewed",                      array: true, comment: "今日意向已接待"
    t.integer  "intention_processed",                        array: true, comment: "今日意向已跟进"
    t.integer  "intention_completed",                        array: true, comment: "今日意向已经成交"
    t.integer  "intention_failed",                           array: true, comment: "今日意向已失败"
    t.integer  "intention_invalid",                          array: true, comment: "今日意向已失效"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "pending_interviewing_finished",              array: true, comment: "今日待接待已完成"
    t.integer  "pending_processing_finished",                array: true, comment: "今日待跟进已完成"
    t.integer  "expired_interviewed_finished",               array: true, comment: "过期未接待已完成"
    t.integer  "expired_processed_finished",                 array: true, comment: "过期未跟进已完成"
  end

  add_index "task_statistics", ["company_id"], name: "index_task_statistics_on_company_id", using: :btree
  add_index "task_statistics", ["record_date"], name: "index_task_statistics_on_record_date", using: :btree
  add_index "task_statistics", ["shop_id"], name: "index_task_statistics_on_shop_id", using: :btree
  add_index "task_statistics", ["user_id"], name: "index_task_statistics_on_user_id", using: :btree

  create_table "token_bills", force: :cascade, comment: "车币账单" do |t|
    t.string   "state",                                     comment: "车币支付状态"
    t.string   "action_type",                               comment: "事件类型"
    t.string   "payment_type",                              comment: "收支类型"
    t.integer  "amount",             limit: 8,              comment: "金额"
    t.integer  "operator_id",                               comment: "事件的操作人"
    t.jsonb    "action_abstraction",                        comment: "事件的概要描述"
    t.integer  "owner_id",                                  comment: "Token的拥有者，可能为公司或个人"
    t.string   "token_type",                                comment: "token类型"
    t.integer  "company_id",                                comment: "操作人所属公司"
    t.integer  "shop_id",                                   comment: "操作人所属店铺"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "token_packages", force: :cascade, comment: "车币套餐" do |t|
    t.string  "name",          comment: "名称"
    t.string  "title",         comment: "标题"
    t.string  "description",   comment: "描述"
    t.integer "price_cents",   comment: "价格"
    t.integer "balance",       comment: "车币"
    t.integer "extra_balance", comment: "赠送车币"
  end

  create_table "tokens", force: :cascade, comment: "车币" do |t|
    t.integer "company_id"
    t.decimal "balance",    precision: 12, scale: 2, default: 0.0
    t.integer "user_id",                                                 comment: "用户个人的车币"
    t.string  "token_type",                          default: "company", comment: "标记个人或公司的车币"
  end

  create_table "transfer_records", force: :cascade, comment: "过户信息" do |t|
    t.integer  "car_id",                                                                             comment: "车辆ID"
    t.string   "vin",                                                                                comment: "车架号"
    t.string   "transfer_record_type",                                                               comment: "过户类型"
    t.string   "state",                                                                              comment: "状态"
    t.text     "items",                                       default: [],              array: true, comment: "手续项目"
    t.integer  "key_count",                                                                          comment: "车钥匙"
    t.string   "contact_person",                                                                     comment: "手续联系人"
    t.string   "contact_mobile",                                                                     comment: "手续联系方式"
    t.string   "original_location_province",                                                         comment: "车辆原属地省份"
    t.string   "original_location_city",                                                             comment: "车辆原属地城市"
    t.string   "current_location_province",                                                          comment: "车辆现属地省份"
    t.string   "current_location_city",                                                              comment: "车辆现属地省份"
    t.string   "original_plate_number",                                                              comment: "原车牌"
    t.string   "current_plate_number",                                                               comment: "现车牌"
    t.string   "new_plate_number",                                                                   comment: "新车牌"
    t.string   "original_owner",                                                                     comment: "原车主"
    t.string   "original_owner_idcard",                                                              comment: "原车主证件号"
    t.string   "original_owner_contact_mobile",                                                      comment: "原车主联系方式"
    t.string   "transfer_recevier",                                                                  comment: "落户人"
    t.string   "transfer_recevier_idcard",                                                           comment: "落户人证件号"
    t.string   "new_owner",                                                                          comment: "新车主"
    t.string   "new_owner_idcard",                                                                   comment: "新车主证件号"
    t.string   "new_owner_contact_mobile",                                                           comment: "新车主联系方式"
    t.string   "inspection_state",                                                                   comment: "验车状态"
    t.integer  "user_id",                                                                            comment: "收购/销售员ID"
    t.date     "estimated_archived_at",                                                              comment: "提档预计完成时间"
    t.integer  "archive_fee_cents",                 limit: 8,                                        comment: "提档费用"
    t.date     "estimated_transferred_at",                                                           comment: "过户预计完成时间"
    t.date     "transferred_at",                                                                     comment: "过户实际完成时间"
    t.integer  "transfer_fee_cents",                limit: 8,                                        comment: "过户费用"
    t.date     "compulsory_insurance_end_at",                                                        comment: "交强险到期日期"
    t.date     "annual_inspection_end_at",                                                           comment: "年审到期日期"
    t.date     "commercial_insurance_end_at",                                                        comment: "商业险到期日"
    t.integer  "commercial_insurance_amount_cents", limit: 8,                                        comment: "商业险金额"
    t.string   "usage_type",                                                                         comment: "使用性质"
    t.string   "registration_number",                                                                comment: "登记证书号"
    t.integer  "transfer_count",                                                                     comment: "过户次数"
    t.string   "engine_number",                                                                      comment: "发动机号"
    t.integer  "allowed_passengers_count",                                                           comment: "核定载客人数"
    t.text     "note",                                                                               comment: "补充说明"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "user_name",                                                                          comment: "收购/销售员名字"
    t.jsonb    "data_completeness",                           default: {},                           comment: "资料完整程度"
    t.integer  "shop_id",                                                                            comment: "分店ID"
    t.integer  "total_transfer_fee_cents",          limit: 8,                                        comment: "过户总费用"
    t.integer  "images_count",                                default: 0,                            comment: "图片数量"
  end

  add_index "transfer_records", ["car_id"], name: "index_transfer_records_on_car_id", using: :btree
  add_index "transfer_records", ["inspection_state"], name: "index_transfer_records_on_inspection_state", using: :btree
  add_index "transfer_records", ["state"], name: "index_transfer_records_on_state", using: :btree
  add_index "transfer_records", ["transfer_record_type", "state"], name: "index_transfer_records_on_transfer_record_type_and_state", using: :btree
  add_index "transfer_records", ["user_id"], name: "index_transfer_records_on_user_id", using: :btree

  create_table "users", force: :cascade, comment: "用户" do |t|
    t.string   "name",                                           null: false,              comment: "姓名"
    t.string   "username",                                                                 comment: "用户名"
    t.string   "password_digest",                                null: false,              comment: "加密密码"
    t.string   "email",                                                                    comment: "邮箱"
    t.string   "pass_reset_token",                                                         comment: "重置密码token"
    t.string   "phone",                                                                    comment: "手机号码"
    t.string   "state",                      default: "enabled",                           comment: "状态"
    t.boolean  "is_alliance_contact",        default: false,                               comment: "是否联盟联系人"
    t.datetime "pass_reset_expired_at",                                                    comment: "重置密码token过期时间"
    t.datetime "last_sign_in_at",                                                          comment: "最后登录时间"
    t.datetime "current_sign_in_at",                                                       comment: "当前登录时间"
    t.integer  "company_id",                                                               comment: "所属公司"
    t.integer  "shop_id",                                                                  comment: "所属分店"
    t.integer  "manager_id",                                                               comment: "所属经理"
    t.text     "note",                                                                     comment: "员工描述"
    t.string   "authority_type",             default: "role",                              comment: "权限选择类型"
    t.text     "authorities",                default: [],                     array: true, comment: "权限"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.datetime "deleted_at",                                                               comment: "删除时间"
    t.string   "avatar",                                                                   comment: "头像URL"
    t.jsonb    "settings",                   default: {},                                  comment: "设置"
    t.string   "mac_address",                                                              comment: "MAC地址"
    t.text     "cross_shop_authorities",     default: [],                     array: true, comment: "跨店权限"
    t.text     "device_numbers",             default: [],                     array: true, comment: "App设备号"
    t.jsonb    "client_info",                                                              comment: "客户端信息"
    t.string   "first_letter",                                                             comment: "拼音"
    t.string   "mobile_app_car_detail_menu",                                  array: true, comment: "移动APP车辆详情页菜单"
    t.string   "rc_token",                                                                 comment: "融云token"
    t.string   "current_device_number",                                                    comment: "用户当前使用的手机设备号"
    t.string   "qrcode_url",                                                               comment: "二维码地址"
    t.text     "self_description",                                                         comment: "自我介绍"
  end

  add_index "users", ["authorities"], name: "users_authorities_alliance_manage", where: "('联盟管理'::text = ANY (authorities))", using: :btree
  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["manager_id"], name: "index_users_on_manager_id", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", using: :btree
  add_index "users", ["shop_id"], name: "index_users_on_shop_id", using: :btree
  add_index "users", ["state", "deleted_at"], name: "index_users_on_state_and_deleted_at", unique: true, where: "(((state)::text = 'enabled'::text) AND (deleted_at IS NULL))", using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree

  create_table "warranties", force: :cascade, comment: "质保等级" do |t|
    t.integer  "company_id",                        comment: "公司ID"
    t.string   "name",                              comment: "名称"
    t.integer  "fee_cents",  limit: 8,              comment: "费用"
    t.datetime "deleted_at",                        comment: "删除时间"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "note",                              comment: "说明"
  end

  add_index "warranties", ["company_id"], name: "index_warranties_on_company_id", using: :btree

  create_table "wechat_apps", force: :cascade, comment: "微信应用" do |t|
    t.string   "app_id",                                                                      comment: "微信公众号app id"
    t.string   "user_name",                                                                   comment: "微信公众号username"
    t.string   "refresh_token",                                                               comment: "重置令牌的token"
    t.text     "authorities",                                                    array: true, comment: "可操作的app权限"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "state",                         default: "enabled",                           comment: "应用状态"
    t.string   "nick_name",                                                                   comment: "授权方昵称"
    t.string   "alias",                                                                       comment: "授权方公众号所设置的微信号"
    t.string   "menus_state",                                                                 comment: "菜单存储状态"
    t.string   "head_img",          limit: 500
    t.integer  "service_type_info",                                                           comment: "公众号类型"
    t.integer  "verify_type_info",                                                            comment: "认证类型"
    t.jsonb    "business_info",                                                               comment: "功能的开通状况（0代表未开通，1代表已开通）"
    t.string   "qrcode_url",        limit: 500,                                               comment: " 二维码图片的URL"
    t.jsonb    "menus",                         default: [],                     array: true
    t.integer  "company_id"
    t.string   "company_type"
  end

  add_index "wechat_apps", ["app_id"], name: "index_wechat_apps_on_app_id", using: :btree
  add_index "wechat_apps", ["company_type", "company_id"], name: "index_wechat_apps_on_company_type_and_company_id", using: :btree
  add_index "wechat_apps", ["user_name"], name: "index_wechat_apps_on_user_name", using: :btree

  create_table "wechat_messages", force: :cascade do |t|
    t.string   "key",                                    comment: "事件key"
    t.string   "app_id",                                 comment: "微信公众号app id"
    t.string   "message_type",                           comment: "消息类型"
    t.jsonb    "content",      default: {},              comment: "消息内容"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "wechat_messages", ["app_id", "key"], name: "index_wechat_messages_on_app_id_and_key", unique: true, using: :btree

  create_table "wechat_records", force: :cascade do |t|
    t.string   "app_id",                               comment: "微信app_id"
    t.string   "open_id",                              comment: "微信用户open id"
    t.string   "action",                               comment: "操作"
    t.jsonb    "data",       default: {},              comment: "数据记录"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "wechat_records", ["app_id", "open_id"], name: "index_wechat_records_on_app_id_and_open_id", using: :btree
  add_index "wechat_records", ["open_id"], name: "index_wechat_records_on_open_id", using: :btree

  create_table "wechat_sharings", force: :cascade do |t|
    t.integer  "user_id",                 comment: "用户ID"
    t.integer  "car_id",                  comment: "车辆ID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wechat_sharings", ["car_id"], name: "index_wechat_sharings_on_car_id", using: :btree
  add_index "wechat_sharings", ["user_id"], name: "index_wechat_sharings_on_user_id", using: :btree

  create_table "wechat_users", force: :cascade, comment: "微信用户" do |t|
    t.string   "open_id",                    comment: "微信用户open id"
    t.integer  "wechat_app_id",              comment: "微信应用ID"
    t.boolean  "subscribed",                 comment: "用户是否关注该应用"
    t.string   "nick_name",                  comment: "微信昵称"
    t.string   "gender",                     comment: "用户性别"
    t.string   "city",                       comment: "所在城市"
    t.string   "province",                   comment: "所在省份"
    t.string   "country",                    comment: "所在国家"
    t.string   "avatar",                     comment: "头像"
    t.string   "note",                       comment: "备注"
    t.integer  "group_code",                 comment: "所在分组ID"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "unionid"
  end

  add_index "wechat_users", ["open_id"], name: "index_wechat_users_on_open_id", using: :btree
  add_index "wechat_users", ["wechat_app_id"], name: "index_wechat_users_on_wechat_app_id", using: :btree

  add_foreign_key "acquisition_car_comments", "acquisition_car_infos"
  add_foreign_key "acquisition_confirmations", "acquisition_car_infos"
  add_foreign_key "acquisition_confirmations", "companies"
  add_foreign_key "acquisition_confirmations", "shops"
  add_foreign_key "alliances", "alliance_companies"
  add_foreign_key "car_alliance_blacklists", "alliances"
  add_foreign_key "car_alliance_blacklists", "cars"
  add_foreign_key "car_info_publish_records", "acquisition_car_infos"
  add_foreign_key "conversations", "users"
  add_foreign_key "easy_loan_authority_roles", "easy_loan_sp_companies"
  add_foreign_key "easy_loan_debits", "companies"
  add_foreign_key "easy_loan_loan_bill_histories", "easy_loan_loan_bills"
  add_foreign_key "easy_loan_users", "easy_loan_authority_roles"
  add_foreign_key "expiration_settings", "companies"
  add_foreign_key "finance_car_fees", "cars"
  add_foreign_key "finance_car_incomes", "cars"
  add_foreign_key "finance_car_incomes", "companies"
  add_foreign_key "finance_shop_fees", "shops"
  add_foreign_key "intention_appointment_cars", "cars"
  add_foreign_key "intention_appointment_cars", "intentions"
  add_foreign_key "intention_expirations", "companies", on_delete: :cascade
  add_foreign_key "intention_shared_users", "intentions"
  add_foreign_key "intention_shared_users", "users"
  add_foreign_key "parallel_styles", "parallel_brands"
end
