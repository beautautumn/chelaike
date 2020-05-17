class Style
  include Mongoid::Document

  field :series_code, type: Integer
  # TODO refactor database
  field :styles, type: Array

  index series_code: 1

  # TODO add has_many, belongs_to
end
