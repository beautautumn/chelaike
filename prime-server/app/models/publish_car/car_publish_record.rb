# == Schema Information
#
# Table name: car_publish_records
#
#  id            :integer          not null, primary key
#  company_id    :integer                                # 公司ID
#  car_id        :integer                                # 发布车辆ID
#  user_id       :integer                                # 发布者ID
#  state         :string           default("processing") # 发布状态
#  error_message :string                                 # 错误信息
#  publish_state :string                                 # 车辆在对应平台的状态
#  type          :string                                 # STI
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  current       :boolean          default(FALSE)        # 是否是当前的记录
#  contactor     :string                                 # 各平台的联系人
#  published_id  :jsonb                                  # 同步到平台的标识，可能为{id: 1234, company_id:4321}
#

module PublishCar
  class CarPublishRecord < ActiveRecord::Base
    attr_accessor :profile

    # accessors .................................................................
    # extends ...................................................................
    extend Enumerize
    # includes ..................................................................
    # relationships .............................................................
    belongs_to :car
    belongs_to :company
    # validations ...............................................................
    # callbacks .................................................................
    after_save :after_save_car_counter_cache
    after_destroy :after_destroy_car_counter_cache
    # scopes ....................................................................
    # additional config .........................................................

    enumerize :state,
              in: %i(pending processing finished failed)
    enumerize :publish_state,
              in: %i(pending reviewing published failed sold)
    # class methods .............................................................
    # public instance methods ...................................................

    def initialize(attributes = nil)
      super
      yield self if block_given?
    end

    def obj_hash
      raise "SubClass resposibility"
    end

    def obj_hash=(*)
      raise "SubClass resposibility"
    end

    # protected instance methods ................................................
    # private instance methods ..................................................

    private

    def after_save_car_counter_cache
      update_car_counter_cache if current_changed?
    end

    def after_destroy_car_counter_cache
      update_car_counter_cache
    end

    def update_car_counter_cache
      car.current_publish_records_count = car.current_publish_records.size
      car.save
    end
  end
end
