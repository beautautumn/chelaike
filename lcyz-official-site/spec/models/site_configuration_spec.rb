# frozen_string_literal: true
# == Schema Information
#
# Table name: site_configurations # 站点配置
#
#  id              :integer          not null, primary key
#  title           :string                                 # SEO title
#  keyword         :string                                 # SEO keyword
#  description     :string                                 # SEO description
#  tenant_id       :integer                                # 所归属租户
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  icon            :string                                 # 网站对应的icon
#  icp             :string                                 # 网站对应的备案号
#  logo            :string                                 # 网站对应的logo
#  slogan          :string                                 # 网站对应的slogan图片
#  statistics_code :string                                 # 统计代码
#

require "rails_helper"

RSpec.describe SiteConfiguration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
