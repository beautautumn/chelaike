class UnionMaintenanceRecord < ActiveRecord::Base
  attr_accessor :error_info
  # 视图对象，缺少字段请改视图、不要写操作
  belongs_to :car
  belongs_to :company
end
