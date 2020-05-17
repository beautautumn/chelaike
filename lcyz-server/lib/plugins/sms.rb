class SMS
  def self.generate_token
    (0...6).map { (0..9).to_a[rand(10)] }.join
  end

  def self.can?(time)
    time ? Time.zone.now - (time - 10.minutes) > 60 : true
  end
end
