class StyleConfiguration
  include Mongoid::Document

  field :series_code, type: Integer
  field :code, type: Integer
  field :data, type: Hash

  index code: 1, series_code: 1

  # TODO add has_many, belongs_to
end
