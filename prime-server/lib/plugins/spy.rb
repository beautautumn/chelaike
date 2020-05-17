class Spy
  def self.search(company_name)
    company_name = company_name.codepoints.map { |c| "%u" + format("%04X", c) }.join
    url = "http://www.che168.com/handler/SeachDealer.ashx?kw=#{company_name}&num=10"
    Timeout.timeout(5) do
      # mock_ip = "http://116.62.100.92:3128"
      # text = open(url, proxy: mock_ip).read
      text = open(url).read

      companies = if [Encoding::GB2312, Encoding::GBK].include? text.encoding
                    JSON.parse(text.force_encoding("gbk").encode("utf-8"))
                  else
                    JSON.parse text
                  end

      companies.map do |company|
        {
          name: company["CompanyName"],
          id: company["DealerId"],
          count: company["CarCount"]
        }
      end
    end
  end
end
