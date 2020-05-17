class EnumerizeLocalesController < ApplicationController
  serialization_scope :anonymous

  skip_before_action :authenticate_user!
  before_action :skip_authorization

  def index
    data = Rails.cache.fetch("EnumerizeLocales") do
      { data: I18n.t("enumerize") }
    end

    render json: data, scope: nil
  end

  def app
    data = Rails.cache.fetch("EnumerizeLocales_java") do
      hash = { data: I18n.t("enumerize") }
      transfer_deep_hash(hash)
    end

    render json: data, scope: nil
  end

  private

  # check?({a: 1, b: 2}) => false
  # check?({ a: { b: 2, c: 3 } }) => true
  def check?(hash)
    hash.values.first.respond_to?(:key)
  end

  # { a: 1, b: 2 }
  # => [ { key: "a", value: "1" }, { key: "b", value: "2" } ]
  def arraish(hash)
    hash.each_with_object([]) do |(key, value), arr|
      arr << { key: key.to_s, value: value.to_s }
    end
  end

  def transfer_deep_hash(hash)
    hash.each_with_object({}) do |(key, value), result|
      result[key] = if check?(value)
                      transfer_deep_hash(value)
                    else
                      arraish(value)
                    end
    end
  end
end
