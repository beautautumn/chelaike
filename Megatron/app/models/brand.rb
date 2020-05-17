class Brand
  include Mongoid::Document

  field :name, type: String
  field :first_letter, type: String
  field :code, type: Integer

  index({ code: 1 }, unique: true)

  # TODO add has_many
end
