class CreateAppVersions < ActiveRecord::Migration
  def change
    create_table :app_versions, comment: "app版本控制" do |t|

      t.string :version_number, comment: "版本号"
      t.string :version_type, comment: "版本类型"
      t.text :note, comment: "发布说明"
      t.string :android_source, comment: "安卓版本下载地址"
      t.string :ipa_source, comment: "苹果版本ipa地址"
      t.string :plist_source, comment: "苹果版本plist地址"

      t.timestamps null: false
    end
  end
end
