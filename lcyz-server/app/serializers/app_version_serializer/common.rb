# == Schema Information
#
# Table name: app_versions # app版本控制
#
#  id               :integer          not null, primary key # app版本控制
#  version_number   :string                                 # 版本号
#  version_type     :string                                 # 版本类型
#  note             :text                                   # 发布说明
#  android_source   :string                                 # 安卓版本下载地址
#  ipa_source       :string                                 # 苹果版本ipa地址
#  plist_source     :string                                 # 苹果版本plist地址
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  version_category :string           default("chelaike")   # 版本类别，如车来客与鸿升车来客
#

module AppVersionSerializer
  class Common < ActiveModel::Serializer
    attributes :id, :version_number, :version_type, :note, :android_source,
               :ipa_source, :plist_source, :created_at, :updated_at, :version_category,
               :force_update
  end
end
