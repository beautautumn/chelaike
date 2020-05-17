# == Schema Information
#
# Table name: public_praise_sumups # 二手车之家口碑总结
#
#  id                 :integer          not null, primary key    # 二手车之家口碑总结
#  brand_name         :string                                    # 品牌
#  series_name        :string                                    # 车系
#  style_name         :string                                    # 车型
#  brand_id           :integer                                   # 品牌ID
#  series_id          :integer                                   # 车系ID
#  style_id           :integer                                   # 车型ID
#  sumup              :jsonb                                     # 总结评价
#  quality_problems   :string           is an Array              # 百车故障
#  latest_exist_links :string           default([]), is an Array # 上一次口碑链接
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PublicPraise::Sumup < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  has_many :records
  # rubocop:disable Style/BlockDelimiters
  has_one :recommendation_record,
          lambda {
            table_name = PublicPraise::Record.table_name

            sql = <<-SQL.squish!
              CASE
              WHEN #{table_name}.level = 'recommendation' THEN 0
              WHEN #{table_name}.level = 'cream' THEN 1
              WHEN #{table_name}.level = 'best' THEN 2
              ELSE 4
              END
            SQL

            order(sql).order(support_count: :desc).order(:viewed_count)
          }, class_name: PublicPraise::Record.name
  # rubocop:enable Style/BlockDelimiters

  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def exist_links
    return [] if sumup.blank?

    sumup.fetch("public_praises").fetch("items")
  end

  def empty?
    return true if sumup.blank?

    sumup["participants"].to_i == 0
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
