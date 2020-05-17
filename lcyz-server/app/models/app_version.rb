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

class AppVersion < ActiveRecord::Base
  class VersionNumber
    SEPARATOR = ".".freeze

    attr_reader :codes

    def initialize(code_string)
      @codes = if code_string =~ /(\d+\.){1,}\d+$/
                 code_string.split(SEPARATOR).map(&:to_i)
               else
                 [0, 0, 0]
               end
    end

    def to_s
      codes.join(SEPARATOR)
    end

    def >=(other)
      compared_codes = other.codes

      codes.each_with_index do |code, index|
        compared_code = compared_codes[index] || 0

        next if code == compared_code

        return code > compared_code
      end

      true
    end
  end
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  has_many :app_version_company_relationships, foreign_key: :version_id, dependent: :destroy
  has_many :companies, through: :app_version_company_relationships, source: :company

  belongs_to :app
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
