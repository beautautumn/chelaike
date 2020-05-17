LetterAvatar.setup do |config|
  config.cache_base_path = "#{Rails.root}/tmp"
  config.font = ENV["LETTER_AVATAR_FONT"]
end
