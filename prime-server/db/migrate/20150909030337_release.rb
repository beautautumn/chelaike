class Release < ActiveRecord::Migration
  def change
    enable_extension "plpgsql"
    enable_extension "hstore"

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
      t.integer  "stock_warning_days",                              default: 30,              comment: "库存预警时间"
      t.text     "note",                                                                      comment: "说明"
      t.datetime "created_at",                                                   null: false
      t.datetime "updated_at",                                                   null: false
    end

    add_index "car_price_histories", ["car_id"], name: "index_car_price_histories_on_car_id", using: :btree
    add_index "car_price_histories", ["user_id"], name: "index_car_price_histories_on_user_id", using: :btree

    create_table "car_reservations", force: :cascade, comment: "车辆预定" do |t|
      t.integer  "car_id",                                                           comment: "车辆ID"
      t.string   "sales_type",                                                       comment: "销售类型"
      t.datetime "reserved_at",                                                      comment: "预约时间"
      t.integer  "customer_channel_id",                                              comment: "客户来源"
      t.integer  "seller_id",                                                        comment: "成交员工"
      t.integer  "closing_cost_cents",         limit: 8,                             comment: "成交价格"
      t.integer  "deposit_cents",              limit: 8,                             comment: "定金"
      t.text     "note",                                                             comment: "备注"
      t.string   "customer_location_province",                                       comment: "客户归属地省份"
      t.string   "customer_location_city",                                           comment: "客户归属地城市"
      t.string   "customer_location_address",                                        comment: "客户归属地详细地址"
      t.string   "customer_name",                                                    comment: "客户姓名"
      t.string   "customer_phone",                                                   comment: "客户电话"
      t.string   "customer_idcard",                                                  comment: "客户证件号"
      t.boolean  "current",                              default: true,              comment: "是否是当前预定"
      t.datetime "created_at",                                          null: false
      t.datetime "updated_at",                                          null: false
      t.integer  "cancelable_price_cents",     limit: 8,                             comment: "退款金额"
      t.datetime "canceled_at",                                                      comment: "退定日期"
      t.string   "seller_name",                                                      comment: "销售员名字"
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
      t.integer  "acquirer_id",                                                                       comment: "收购员"
      t.datetime "acquired_at",                                                                       comment: "收购日期"
      t.integer  "channel_id",                                                                        comment: "收购渠道"
      t.string   "acquisition_type",                                                                  comment: "收购类型"
      t.integer  "acquisition_price_cents",        limit: 8,                                          comment: "收购价"
      t.string   "stock_number",                                                                      comment: "库存编号"
      t.string   "vin",                                                                               comment: "车架号"
      t.string   "state",                                                                             comment: "车辆状态"
      t.string   "state_note",                                                                        comment: "车辆备注"
      t.string   "brand_name",                                                                        comment: "品牌名称"
      t.string   "manufacturer_name",                                                                 comment: "厂商名称"
      t.string   "series_name",                                                                       comment: "车系名称"
      t.string   "style_name",                                                                        comment: "车型名称"
      t.string   "car_type",                                                                          comment: "车辆类型"
      t.integer  "door_count",                                                                        comment: "门数"
      t.string   "displacement",                                                                      comment: "排气量"
      t.string   "fuel_type",                                                                         comment: "燃油类型"
      t.boolean  "is_turbo_charger",                                                                  comment: "涡轮增压"
      t.string   "transmission",                                                                      comment: "变速箱"
      t.string   "exterior_color",                                                                    comment: "外饰颜色"
      t.string   "interior_color",                                                                    comment: "内饰颜色"
      t.float    "mileage",                                                                           comment: "表显里程(万公里)"
      t.float    "mileage_in_fact",                                                                   comment: "实际里程(万公里)"
      t.string   "emission_standard",                                                                 comment: "排放标准"
      t.string   "license_info",                                                                      comment: "牌证信息"
      t.date     "licensed_at",                                                                       comment: "首次上牌日期"
      t.date     "manufactured_at",                                                                   comment: "出厂日期"
      t.integer  "show_price_cents",               limit: 8,                                          comment: "展厅价格"
      t.integer  "online_price_cents",             limit: 8,                                          comment: "网络标价"
      t.integer  "sales_minimun_price_cents",      limit: 8,                                          comment: "销售底价"
      t.integer  "manager_price_cents",            limit: 8,                                          comment: "经理价"
      t.integer  "alliance_minimun_price_cents",   limit: 8,                                          comment: "联盟底价"
      t.integer  "new_car_guide_price_cents",      limit: 8,                                          comment: "新车指导价"
      t.integer  "new_car_additional_price_cents", limit: 8,                                          comment: "新车加价"
      t.float    "new_car_discount",                                                                  comment: "新车优惠折扣"
      t.integer  "new_car_final_price_cents",      limit: 8,                                          comment: "新车完税价"
      t.text     "interior_note",                                                                     comment: "车辆内部描述"
      t.integer  "star_rating",                                                                       comment: "车辆星级"
      t.integer  "warranty_id",                                                                       comment: "质保等级"
      t.integer  "warranty_fee_cents",             limit: 8,                                          comment: "质保费用"
      t.boolean  "is_fixed_price",                                                                    comment: "是否一口价"
      t.boolean  "allowed_mortgage",                                                                  comment: "是否可按揭"
      t.text     "mortgage_note",                                                                     comment: "按揭说明"
      t.text     "selling_point",                                                                     comment: "卖点描述"
      t.float    "maintain_mileage",                                                                  comment: "保养里程"
      t.boolean  "has_maintain_history",                                                              comment: "有无保养记录"
      t.string   "new_car_warranty",                                                                  comment: "新车质保"
      t.text     "standard_equipment",                       default: [],                array: true, comment: "厂家标准配置"
      t.text     "personal_equipment",                       default: [],                array: true, comment: "车主个性配置"
      t.datetime "created_at",                                              null: false
      t.datetime "updated_at",                                              null: false
      t.integer  "stock_age_days",                           default: 0,                              comment: "库龄"
      t.integer  "age",                                                                               comment: "车龄"
      t.boolean  "sellable",                                 default: true,                           comment: "是否可售"
      t.jsonb    "states_statistic",                         default: {},                             comment: "状态统计"
      t.datetime "state_changed_at",                                                                  comment: "状态修改时间"
      t.integer  "stock_warning_days",                       default: 30,                             comment: "库存预警"
      t.string   "imported"
      t.datetime "reserved_at",                                                                       comment: "预约时间"
      t.string   "consignor_name",                                                                    comment: "寄卖人"
      t.string   "consignor_phone",                                                                   comment: "寄卖人电话"
      t.integer  "consignor_price_cents",          limit: 8,                                          comment: "寄卖价格"
      t.datetime "deleted_at",                                                                        comment: "删除时间"
      t.datetime "stock_out_at",                                                                      comment: "出库时间"
      t.integer  "closing_cost_cents",             limit: 8,                                          comment: "成交价格"
      t.hstore   "manufacturer_configuration"
      t.datetime "predicted_restocked_at",                                                            comment: "预计回厅时间"
    end

    add_index "cars", ["acquirer_id"], name: "index_cars_on_acquirer_id", using: :btree
    add_index "cars", ["channel_id"], name: "index_cars_on_channel_id", using: :btree
    add_index "cars", ["mileage"], name: "index_cars_on_mileage", using: :btree
    add_index "cars", ["stock_number"], name: "index_cars_on_stock_number", using: :btree

    create_table "channels", force: :cascade, comment: "渠道设置" do |t|
      t.integer  "company_id",              comment: "公司ID"
      t.string   "name",                    comment: "名称"
      t.text     "note",                    comment: "备注"
      t.datetime "deleted_at",              comment: "删除时间"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "channels", ["company_id"], name: "index_channels_on_company_id", using: :btree
    add_index "channels", ["deleted_at"], name: "index_channels_on_deleted_at", using: :btree

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
      t.string   "name",                                         comment: "名称"
      t.string   "contact",                                      comment: "联系人"
      t.string   "contact_mobile",                               comment: "联系人电话"
      t.string   "acquisition_mobile",                           comment: "收购电话"
      t.string   "sale_mobile",                                  comment: "销售电话"
      t.string   "logo",                                         comment: "LOGO"
      t.string   "note",                                         comment: "备注"
      t.string   "province",                                     comment: "省份"
      t.string   "city",                                         comment: "城市"
      t.string   "district",                                     comment: "区"
      t.string   "street",                                       comment: "详细地址"
      t.integer  "owner_id",                                     comment: "公司拥有者ID"
      t.datetime "created_at",                      null: false
      t.datetime "updated_at",                      null: false
      t.jsonb    "settings",           default: {},              comment: "设置"
      t.datetime "deleted_at",                                   comment: "删除时间"
    end

    create_table "cooperation_companies", force: :cascade, comment: "合作商家" do |t|
      t.integer  "company_id",              comment: "公司ID"
      t.string   "name",                    comment: "名称"
      t.datetime "deleted_at",              comment: "删除时间"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "cooperation_companies", ["company_id"], name: "index_cooperation_companies_on_company_id", using: :btree
    add_index "cooperation_companies", ["deleted_at"], name: "index_cooperation_companies_on_deleted_at", using: :btree

    create_table "cooperation_company_relationships", force: :cascade, comment: "合作商家关联表" do |t|
      t.integer  "car_id",                                         comment: "车辆ID"
      t.integer  "cooperation_company_id",                         comment: "合作商家ID"
      t.integer  "cooperation_price_cents", limit: 8,              comment: "合作价格"
      t.datetime "created_at",                        null: false
      t.datetime "updated_at",                        null: false
    end

    add_index "cooperation_company_relationships", ["car_id"], name: "index_cooperation_company_relationships_on_car_id", using: :btree
    add_index "cooperation_company_relationships", ["cooperation_company_id"], name: "relationships_on_company_id", using: :btree

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

    create_table "feedbacks", force: :cascade, comment: "用户反馈" do |t|
      t.string   "note",                    comment: "反馈内容"
      t.integer  "user_id",                 comment: "用户ID"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "images", force: :cascade do |t|
      t.integer  "imageable_id",                                comment: "多态ID"
      t.string   "imageable_type",                              comment: "多态名"
      t.string   "url",                                         comment: "图片URL"
      t.string   "name",                                        comment: "名称"
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
      t.string   "location",                                    comment: "图片位置"
      t.boolean  "is_cover",       default: false,              comment: "是否为LOGO"
    end

    add_index "images", ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type", using: :btree

    create_table "insurance_companies", force: :cascade, comment: "保险公司" do |t|
      t.integer  "company_id",              comment: "公司ID"
      t.string   "name",                    comment: "名称"
      t.datetime "deleted_at",              comment: "删除时间"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "insurance_companies", ["company_id"], name: "index_insurance_companies_on_company_id", using: :btree
    add_index "insurance_companies", ["deleted_at"], name: "index_insurance_companies_on_deleted_at", using: :btree

    create_table "messages", force: :cascade, comment: "消息" do |t|
      t.integer  "user_id",                                          comment: "用户ID"
      t.integer  "operation_record_id",                              comment: "操作历史ID"
      t.boolean  "read",                default: false,              comment: "是否已读"
      t.datetime "read_at",                                          comment: "阅读时间"
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
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
    add_index "mortgage_companies", ["deleted_at"], name: "index_mortgage_companies_on_deleted_at", using: :btree

    create_table "operation_records", force: :cascade, comment: "操作历史" do |t|
      t.integer  "targetable_id",                                   comment: "多态ID"
      t.string   "targetable_type",                                 comment: "多态类型"
      t.string   "operation_record_type",                           comment: "事件类型"
      t.datetime "created_at",                         null: false
      t.datetime "updated_at",                         null: false
      t.integer  "user_id",                                         comment: "操作人ID"
      t.jsonb    "messages",              default: {},              comment: "操作信息"
      t.integer  "company_id",                                      comment: "公司ID"
    end

    add_index "operation_records", ["operation_record_type"], name: "index_operation_records_on_operation_record_type", using: :btree
    add_index "operation_records", ["targetable_id", "targetable_type"], name: "index_operation_records_on_targetable_id_and_targetable_type", using: :btree

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
      t.integer  "car_id",                                    comment: "车辆ID"
      t.string   "state",                                     comment: "整备状态"
      t.integer  "total_amount_cents", limit: 8,              comment: "费用合计"
      t.date     "start_at",                                  comment: "开始时间"
      t.date     "end_at",                                    comment: "结束时间"
      t.string   "repair_state",                              comment: "维修现状"
      t.text     "note",                                      comment: "补充说明"
      t.datetime "created_at",                   null: false
      t.datetime "updated_at",                   null: false
    end

    add_index "prepare_records", ["car_id"], name: "index_prepare_records_on_car_id", using: :btree

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

    create_table "shops", force: :cascade, comment: "店" do |t|
      t.string   "name",                    comment: "名称"
      t.integer  "company_id",              comment: "所属公司"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "shops", ["company_id"], name: "index_shops_on_company_id", using: :btree

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
    end

    add_index "stock_out_inventories", ["car_id"], name: "index_stock_out_inventories_on_car_id", using: :btree
    add_index "stock_out_inventories", ["customer_channel_id"], name: "index_stock_out_inventories_on_customer_channel_id", using: :btree
    add_index "stock_out_inventories", ["insurance_company_id"], name: "index_stock_out_inventories_on_insurance_company_id", using: :btree
    add_index "stock_out_inventories", ["mortgage_company_id"], name: "index_stock_out_inventories_on_mortgage_company_id", using: :btree
    add_index "stock_out_inventories", ["returned_at"], name: "index_stock_out_inventories_on_returned_at", using: :btree
    add_index "stock_out_inventories", ["sales_type"], name: "index_stock_out_inventories_on_sales_type", using: :btree
    add_index "stock_out_inventories", ["seller_id"], name: "index_stock_out_inventories_on_seller_id", using: :btree

    create_table "transfer_records", force: :cascade, comment: "过户信息" do |t|
      t.integer  "car_id",                                                                             comment: "车辆ID"
      t.string   "vin",                                                                                comment: "车架号"
      t.string   "transfer_record_type",                                                               comment: "过户类型"
      t.string   "state",                                                                              comment: "状态"
      t.text     "items",                                       default: [],              array: true, comment: "手续项目"
      t.integer  "key_count",                                                                          comment: "车钥匙"
      t.string   "environment_mark",                                                                   comment: "车辆环保标识"
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
    end

    add_index "transfer_records", ["car_id"], name: "index_transfer_records_on_car_id", using: :btree
    add_index "transfer_records", ["inspection_state"], name: "index_transfer_records_on_inspection_state", using: :btree
    add_index "transfer_records", ["state"], name: "index_transfer_records_on_state", using: :btree
    add_index "transfer_records", ["transfer_record_type"], name: "index_transfer_records_on_transfer_record_type", using: :btree
    add_index "transfer_records", ["user_id"], name: "index_transfer_records_on_user_id", using: :btree

    create_table "users", force: :cascade, comment: "用户" do |t|
      t.string   "name",                                      null: false,              comment: "姓名"
      t.string   "username",                                                            comment: "用户名"
      t.string   "password_digest",                           null: false,              comment: "加密密码"
      t.string   "email",                                                               comment: "邮箱"
      t.string   "pass_reset_token",                                                    comment: "重置密码token"
      t.string   "phone",                                                               comment: "手机号码"
      t.string   "state",                 default: "enabled",                           comment: "状态"
      t.boolean  "is_aliance_contact",                                                  comment: "是否联盟联系人"
      t.datetime "pass_reset_expired_at",                                               comment: "重置密码token过期时间"
      t.datetime "last_sign_in_at",                                                     comment: "最后登录时间"
      t.datetime "current_sign_in_at",                                                  comment: "当前登录时间"
      t.integer  "company_id",                                                          comment: "所属公司"
      t.integer  "shop_id",                                                             comment: "所属分店"
      t.integer  "manager_id",                                                          comment: "所属经理"
      t.text     "note",                                                                comment: "员工描述"
      t.string   "authority_type",        default: "role",                              comment: "权限选择类型"
      t.text     "authorities",           default: [],                     array: true, comment: "权限"
      t.datetime "created_at",                                null: false
      t.datetime "updated_at",                                null: false
      t.datetime "deleted_at",                                                          comment: "删除时间"
      t.string   "avatar",                                                              comment: "头像URL"
    end

    add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
    add_index "users", ["shop_id"], name: "index_users_on_shop_id", using: :btree

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
    add_index "warranties", ["deleted_at"], name: "index_warranties_on_deleted_at", using: :btree

    create_table "wechat_sharings", force: :cascade do |t|
      t.integer  "user_id",                 comment: "用户ID"
      t.integer  "car_id",                  comment: "车辆ID"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    add_index "wechat_sharings", ["car_id"], name: "index_wechat_sharings_on_car_id", using: :btree
    add_index "wechat_sharings", ["user_id"], name: "index_wechat_sharings_on_user_id", using: :btree
  end
end
