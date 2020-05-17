class Series
  include Mongoid::Document

  field :name, type: String
  field :code, type: Integer
  field :brand_code, type: Integer
  field :manufacturer, type: String

  index code: 1

  # TODO add has_many, belongs_to
end
