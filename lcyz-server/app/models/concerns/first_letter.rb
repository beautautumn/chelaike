module FirstLetter
  extend ActiveSupport::Concern

  included do
    before_save :set_first_letter
  end

  def set_first_letter
    return unless new_record? || name_changed?

    letter = Util::Surname.first_letter(name)

    return if letter.blank?

    self.first_letter = letter
  end
end
