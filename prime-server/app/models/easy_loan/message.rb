# == Schema Information
#
# Table name: easy_loan_messages # 车融易里的消息
#
#  id                            :integer          not null, primary key # 车融易里的消息
#  user_id                       :integer                                # 对应user
#  user_type                     :string                                 # user多态
#  easy_loan_operation_record_id :integer                                # 对应的车融易里操作记录
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class EasyLoan::Message < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :user, polymorphic: true
  belongs_to :operation_record,
             class_name: "EasyLoan::OperationRecord",
             foreign_key: :easy_loan_operation_record_id
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................

  class << self
    def create_messages(operation_record, target_ids = nil)
      now = Time.zone.now

      query = target_ids.inject("") do |sql, user_id|
        sql << <<-SQL
            INSERT INTO #{EasyLoan::Message.table_name}
            (user_id, user_type, easy_loan_operation_record_id, created_at, updated_at)
            VALUES
            ('#{user_id}', 'EasyLoan::User', '#{operation_record.id}', '#{now}', '#{now}');
            SQL
      end

      EasyLoan::Message.connection.execute(query.squish!)
    end
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
