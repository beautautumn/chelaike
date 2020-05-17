# == Schema Information
#
# Table name: tokens # 车币
#
#  id         :integer          not null, primary key # 车币
#  company_id :integer
#  balance    :decimal(12, 2)   default(0.0)
#  user_id    :integer                                # 用户个人的车币
#  token_type :string           default("company")    # 标记个人或公司的车币
#

class Token < ActiveRecord::Base
  class TypeError < StandardError; end
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :company
  belongs_to :user
  # validations ...............................................................
  validates :company_id, uniqueness: true, allow_nil: true
  validates :user_id, uniqueness: true, allow_nil: true
  validates :token_type, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  enumerize :token_type, in: %i(user company), default: :company
  # class methods .............................................................

  class << self
    def associated_order(order)
      case order.token_type
      when "user"
        find_or_create_by!(user_id: order.user_id)
      when "company"
        find_or_create_by!(company_id: order.company_id)
      else
        find_or_create_by!(company_id: order.company_id)
      end
    end

    def get_token(obj)
      case obj
      when Company
        find_by(company_id: obj, token_type: :company)
      when User
        find_by(user_id: obj, token_type: :user)
      end
    end

    def get_or_create_token!(obj)
      case obj
      when Company
        find_or_create_by!(company_id: obj.id, token_type: :company)
      when User
        find_or_create_by!(user_id: obj.id, token_type: :user)
      end
    end
  end

  # public instance methods ...................................................

  def format_balance
    format("%.2f", balance.to_f)
  end

  def increment_balance!(type, amount_yuan)
    raise TypeError unless token_type.to_s == type.to_s
    Token.transaction do
      increment(:balance, amount_yuan)
      save!
    end
  end

  def owner_id
    case token_type
    when "user"
      user_id
    when "company"
      company_id
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
