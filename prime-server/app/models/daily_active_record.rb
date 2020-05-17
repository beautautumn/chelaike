# == Schema Information
#
# Table name: daily_active_records # 统计用户日活
#
#  id         :integer          not null, primary key # 统计用户日活
#  user_id    :integer                                # user_id
#  request_ip :string                                 # 请求的来源IP
#  url        :string                                 # 请求的地址
#  region     :string                                 # 省份
#  city       :string                                 # 城市
#  company_id :integer                                # 用户所属店家的id
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  url_path   :string                                 # 请求的接口
#  url_query  :jsonb                                  # 请求的参数
#

class DailyActiveRecord < ActiveRecord::Base
  class HashSerializer
    def self.dump(hash)
      hash.to_json
    end

    def self.load(hash)
      (hash || {}).with_indifferent_access
    end
  end

  serialize :url_query, HashSerializer
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
