# == Schema Information
#
# Table name: intentions # 意向
#
#  id                    :integer          not null, primary key     # 意向
#  customer_id           :integer                                    # 客户ID
#  customer_name         :string                                     # 客户姓名
#  intention_type        :string                                     # 意向类型
#  creator_id            :integer                                    # 意向创建者
#  assignee_id           :integer                                    # 分配员工ID
#  province              :string                                     # 省份
#  city                  :string                                     # 城市
#  intention_level_id    :integer                                    # 意向级别ID
#  channel_id            :integer                                    # 客户渠道
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :integer                                    # 公司ID
#  shop_id               :integer                                    # 店ID
#  customer_phones       :string           default([]), is an Array  # 客户联系方式
#  state                 :string           default("pending")        # 跟进状态
#  customer_phone        :string                                     # 客户电话
#  intention_note        :text                                       # 意向描述
#  gender                :string                                     # 性别
#  brand_name            :string                                     # 出售车辆品牌名称
#  series_name           :string                                     # 出售车辆车系名称
#  color                 :string                                     # 颜色
#  mileage               :float                                      # 里程(万公里)
#  licensed_at           :date                                       # 上牌日期
#  minimum_price_cents   :integer                                    # 最低价格
#  maximum_price_cents   :integer                                    # 最高价格
#  estimated_price_cents :integer                                    # 评估车价
#  seeking_cars          :jsonb            is an Array               # 求购车辆
#  style_name            :string                                     # 出售车辆车款名称
#  interviewed_time      :datetime                                   # 预约时间
#  processing_time       :datetime                                   # 跟进时间
#  checked_count         :integer          default(0)                # 到店/评估次数
#  consigned_at          :date                                       # 寄卖时间
#  deleted_at            :datetime                                   # 删除时间
#  source                :string           default("user_operation") # 意向产生来源
#  import_task_id        :integer                                    # 意向导入记录ID
#  source_car_id         :integer                                    # 来源车辆ID
#  source_company_id     :integer                                    # 来源公司ID
#  deposit_cents         :integer                                    # 定金
#  closing_cost_cents    :integer                                    # 成交价格
#  closing_car_id        :integer                                    # 成交车辆ID
#  closing_car_name      :string                                     # 成交车辆名称
#  creator_type          :string                                     # 意向创建者多态
#  alliance_company_id   :integer
#  alliance_assignee_id  :integer                                    # 联盟用户ID
#  earnest               :boolean          default(FALSE)            # 是否已收意向金
#

module IntentionSerializer
  class Detail < ActiveModel::Serializer
    attributes :id, :customer_id, :customer_name, :intention_type, :creator_id,
               :assignee_id, :province, :city, :intention_level_id, :channel_id,
               :created_at, :updated_at, :company_id, :shop_id, :customer_phones,
               :state, :customer_phone, :intention_note, :gender, :seeking_cars,
               :brand_name, :series_name, :style_name, :minimum_price_wan, :maximum_price_wan,
               :color, :mileage, :licensed_at, :interviewed_time, :processing_time,
               :estimated_price_wan, :checked_count, :last_estimated_price_wan,
               :consigned_at, :deposit_wan, :closing_cost_wan, :closing_car_name,
               :shared_users, :shared, :earnest, :annual_inspection_notify_date,
               :insurance_notify_date, :mortgage_notify_date,
               :annual_inspection_notify_date_flag, :insurance_notify_date_flag,
               :mortgage_notify_date_flag, :memory_dates_with_flag,
               :finished_payment_type

    has_many :intention_push_histories,
             serializer: IntentionPushHistorySerializer::Common

    belongs_to :assignee, serializer: UserSerializer::Basic
    belongs_to :after_sale_assignee, serializer: UserSerializer::Basic
    belongs_to :creator, serializer: UserSerializer::Basic
    belongs_to :channel, serializer: ChannelSerializer::Common
    belongs_to :intention_level, serializer: IntentionLevelSerializer::Common
    belongs_to :source_company, serializer: CompanySerializer::Mini
    belongs_to :source_car, serializer: CarSerializer::Mini
    belongs_to :closing_car, serializer: CarSerializer::Mini

    def last_estimated_price_wan
      last_push = object.intention_push_histories.last

      last_push.present? ? last_push.estimated_price_wan : nil
    end

    [:annual_inspection, :insurance, :mortgage].each do |notify_type|
      define_method "#{notify_type}_notify_date_flag" do
        current_date = Time.zone.today
        setting_date = object.send("#{notify_type}_notify_date")

        return "" if setting_date.blank?

        setting = object.company.expiration_settings.where(notify_type: notify_type).first

        first_day = setting.first_notify.presence || 0

        remaining_days = (setting_date - current_date).to_i

        if remaining_days <= 0
          "expired"
        elsif remaining_days < first_day
          "almost_expired"
        end
      end
    end

    def shared_users
      object.intention_shared_users.pluck(:user_id)
    end

    def shared
      object.assignee_id != current_user.id
    end
  end
end
