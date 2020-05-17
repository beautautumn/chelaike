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
#  app_id           :integer
#  force_update     :boolean          default(FALSE)        # 强制更新
#

require "rails_helper"

RSpec.describe AppVersion, type: :model do
  it ".new" do
    cases = {
      ""      => [0, 0, 0],
      nil     => [0, 0, 0],
      "123"   => [0, 0, 0],
      "1.2.3" => [1, 2, 3]
    }

    cases.each do |str, result|
      expect(AppVersion::VersionNumber.new(str).codes).to eq result
    end
  end

  it ">=" do
    cases = [
      ["1.0.0", "2.3.4", true],
      ["1.1.2", "2.3.4", true],
      ["1.8.1", "2.3.4", true],
      ["1.8.8", "2.3.4", true],
      ["2.8.8", "2.3.4", false],
      ["2.3.4", "3.0.1", true],
      ["2.3.4", "3.9.1.1", true],
      ["1.9",   "2.3.4", true],
      ["2.3.4", "2.6", true],
      ["1.2.3", "1.11.3", true],
      ["1.11.3", "1.2.3", false],
      ["2.3.4", "2.3.4", true]
    ]

    cases.each do |version1, version2, result|
      app_version1 = AppVersion::VersionNumber.new(version1)
      app_version2 = AppVersion::VersionNumber.new(version2)

      expect(app_version2 >= app_version1).to eq result
    end
  end
end
