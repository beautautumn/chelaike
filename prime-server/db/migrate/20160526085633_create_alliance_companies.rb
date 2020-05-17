class CreateAllianceCompanies < ActiveRecord::Migration
  def change
    create_table :alliance_companies, comment: "联盟公司" do |t|
      t.string   "name",                                                           comment: "名称"
      t.string   "contact",                                                        comment: "联系人"
      t.string   "contact_mobile",                                                 comment: "联系人电话"
      t.string   "sale_mobile",                                                    comment: "销售电话"
      t.string   "logo",                                                           comment: "LOGO"
      t.string   "note",                                                           comment: "备注"
      t.string   "province",                                                       comment: "省份"
      t.string   "city",                                                           comment: "城市"
      t.string   "district",                                                       comment: "区"
      t.string   "street",                                                         comment: "详细地址"
      t.integer  "owner_id",                                                       comment: "公司拥有者ID"
      t.datetime "created_at",                           null: false
      t.datetime "updated_at",                           null: false
      t.jsonb    "settings",              default: {},                             comment: "设置"
      t.datetime "deleted_at",                                                     comment: "删除时间"
      t.text     "slogan",                                                         comment: "宣传语"
      t.string   "qrcode",                                                         comment: "商家二维码"
      t.string   "banners",                                           array: true, comment: "网站Banners"

      t.timestamps null: false
    end
  end
end
