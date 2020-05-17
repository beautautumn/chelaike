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
  class Basic < ActiveModel::Serializer
    attributes :id, :customer_id, :customer_name, :intention_type, :creator_id,
               :assignee_id, :province, :city, :intention_level_id, :channel_id,
               :created_at, :updated_at, :company_id, :shop_id, :customer_phones,
               :state, :customer_phone, :intention_note, :gender, :seeking_cars,
               :brand_name, :series_name, :style_name, :minimum_price_wan, :maximum_price_wan,
               :color, :mileage, :licensed_at, :interviewed_time, :processing_time,
               :estimated_price_wan, :checked_count, :consigned_at,
               :deposit_wan, :closing_cost_wan, :closing_car_name,
               :shared_users, :shared, :earnest, :alliance_assigned_at, :in_shop_at,
               :alliance_state, :alliance_intention_level_id,
               :after_sale_assignee_id

    belongs_to :company, serializer: CompanySerializer::Mini
    belongs_to :creator, serializer: UserSerializer::Mini
    belongs_to :assignee, serializer: UserSerializer::Mini
    belongs_to :after_sale_assignee, serializer: UserSerializer::Mini
    belongs_to :channel, serializer: ChannelSerializer::Common
    belongs_to :intention_level, serializer: IntentionLevelSerializer::Common
    belongs_to :source_company, serializer: CompanySerializer::Mini
    belongs_to :source_car, serializer: CarSerializer::Mini
    belongs_to :closing_car, serializer: CarSerializer::Mini

    def shared_users
      object.intention_shared_users.pluck(:user_id)
    end

    def shared
      object.assignee_id != current_user.id
    end
  end
end
