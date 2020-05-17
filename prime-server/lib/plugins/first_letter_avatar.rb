class FirstLetterAvatar
  def self.url(letters)
    return "" if letters.blank?

    fetch(first_letter(letters))
  end

  def self.fetch(letter)
    Rails.cache.fetch(cache_key(letter)) { virtual_avatar(letter) }
  end

  def self.virtual_avatar(letter)
    file_name = URI.encode("letter_avatars/#{letter}.png")

    AvatarWorker.perform_async(letter, file_name)

    "#{image_host}/#{file_name}"
  end

  def self.first_letter(letters)
    letters.first.upcase
  end

  def self.cache_key(letter)
    "letter_avatar:#{Digest::MD5.hexdigest(letter)}"
  end

  # 返回一个以 customer.id 为 key, cache 为值的 Hash
  def self.batch_avatars(customers)
    hash = {}.tap do |h|
      customers.each do |customer|
        next if customer.name.blank?

        key = cache_key(first_letter(customer.name))
        h[key] = customer.id
      end
    end

    {}.tap do |batch_avatars|
      Rails.cache.read_multi(*hash.keys).each do |key, cache|
        batch_avatars[hash[key]] = cache
      end
    end
  end

  def self.image_host
    "#{ENV.fetch("IMAGE_HOST")}/#{ENV.fetch("OSS_IMAGE_FOLDER")}"
  end
end
