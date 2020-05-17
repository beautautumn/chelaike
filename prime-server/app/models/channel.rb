# == Schema Information
#
# Table name: channels # 渠道设置
#
#  id           :integer          not null, primary key # 渠道设置
#  company_id   :integer                                # 公司ID
#  name         :string                                 # 名称
#  note         :text                                   # 备注
#  deleted_at   :datetime                               # 删除时间
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_type :string                                 # 渠道所属公司多态
#

class Channel < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company, polymorphic: true
  has_many :cars
  has_many :stock_out_inventories,
           foreign_key: :customer_channel_id
  has_many :car_reservations,
           foreign_key: :customer_channel_id

  # validations ...............................................................
  validates :name, presence: true, uniqueness_without_deleted: { scope: :company_id }
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  acts_as_paranoid
  # class methods .............................................................
  # public instance methods ...................................................
  def wechat_qrcode_url
    cache_key = "wechat:qrcode:channel:#{id}"
    if company.wechat_app && company.wechat_app.state.enabled?
      Rails.cache.fetch(cache_key) do
        scene = Wechat::Reducer.scan_scene(Wechat::Reducer::CHANNEL_SCAN, id)
        Wechat::Mp::Qrcode.generate(company.wechat_app.app_id, scene)
      end
    end
  rescue Wechat::Error::Unauthenticated
    nil
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
