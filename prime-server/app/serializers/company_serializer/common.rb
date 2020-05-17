# == Schema Information
#
# Table name: companies # 公司
#
#  id                    :integer          not null, primary key # 公司
#  name                  :string                                 # 名称
#  contact               :string                                 # 联系人
#  contact_mobile        :string                                 # 联系人电话
#  acquisition_mobile    :string                                 # 收购电话
#  sale_mobile           :string                                 # 销售电话
#  logo                  :string                                 # LOGO
#  note                  :string                                 # 备注
#  province              :string                                 # 省份
#  city                  :string                                 # 城市
#  district              :string                                 # 区
#  street                :string                                 # 详细地址
#  owner_id              :integer                                # 公司拥有者ID
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  settings              :jsonb                                  # 设置
#  deleted_at            :datetime                               # 删除时间
#  md5_name              :string                                 # 兼容老系统的名称MD5值
#  slogan                :text                                   # 宣传语
#  alliances_count       :integer                                # 联盟数量
#  cars_count            :integer                                # 车辆数量
#  active_tag            :boolean          default(FALSE)        # 活跃标识
#  honesty_tag           :boolean                                # 诚信标识
#  own_brand_tag         :boolean                                # 品牌商家标识
#  app_secret            :string                                 # 商家secret
#  youhaosuda_shop_token :string                                 # 友好速搭商铺Token
#  open_alliance_id      :integer                                # 开放联盟ID
#  erp_id                :string                                 # ERP 识别号
#  erp_url               :string                                 # ERP 通知地址
#  che168_profile        :jsonb                                  # che168信息
#  qrcode                :string                                 # 商家二维码
#  banners               :string           is an Array           # 网站Banners
#

module CompanySerializer
  class Common < ActiveModel::Serializer
    attributes :id, :name, :contact, :contact_mobile, :acquisition_mobile,
               :sale_mobile, :logo, :note, :province, :city, :district,
               :street, :owner_id, :created_at, :settings, :in_alliances,
               :cars_count, :qrcode, :banners, :shops_count, :nickname,
               :facade, :accredited

    belongs_to :owner, serializer: UserSerializer::Basic
  end
end
