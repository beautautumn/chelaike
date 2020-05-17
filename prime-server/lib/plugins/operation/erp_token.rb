# rubocop:disable Rails/Output
module Operation
  class ErpToken
    def self.by_phones(phones)
      phones.each do |phone|
        puts "#{phone} 信息: "
        user = User.find_by(phone: phone)
        if user.blank?
          puts "不存在"
          next
        end

        puts <<-TXT
          ID: #{user.id}
          公司ID: #{user.company_id}
          token: #{user.simple_token}
        TXT
      end
    end
  end
end
# rubocop:enable Rails/Output
