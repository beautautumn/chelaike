# == Schema Information
#
# Table name: messages # 消息
#
#  id                  :integer          not null, primary key # 消息
#  user_id             :integer                                # 用户ID
#  operation_record_id :integer                                # 操作历史ID
#  read                :boolean          default(FALSE)        # 是否已读
#  read_at             :datetime                               # 阅读时间
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_type           :string
#

class Message < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :user, polymorphic: true
  belongs_to :operation_record, lambda {
    where(operation_record_type: OperationRecord.messagable_types)
  }
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :unread, -> { where(read: false) }
  # additional config .........................................................
  # class methods .............................................................
  def self.create_messages(operation_record, target_ids = nil)
    now = Time.zone.now

    unless target_ids
      target_ids = User.where(company_id: operation_record.company_id).pluck(:id)
    end

    query = target_ids.inject("") do |sql, user_id|
      sql << <<-SQL
        INSERT INTO #{Message.table_name}
          (user_id, operation_record_id, created_at, updated_at)
          VALUES
          ('#{user_id}', '#{operation_record.id}', '#{now}', '#{now}');
      SQL
    end

    Message.connection.execute(query.squish!)
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
