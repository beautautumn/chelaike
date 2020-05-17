module Util
  class Request
    def self.get(url, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :get, url: url), &block
      )
    end

    def self.post(url, payload = {}, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :post, url: url, payload: payload), &block
      )
    end

    def self.patch(url, payload = {}, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :patch, url: url, payload: payload), &block
      )
    end

    def self.put(url, payload = {}, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :put, url: url, payload: payload), &block
      )
    end

    def self.delete(url, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :delete, url: url), &block
      )
    end

    def self.head(url, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :head, url: url), &block
      )
    end

    def self.options(url, args = {}, &block)
      RestClient::Request.execute(
        args.merge!(method: :options, url: url), &block
      )
    end

    def self.proxy_url
      Rails.cache.fetch("REQUEST:PROXY_URL") do
        YAML.load_file("#{Rails.root}/config/proxy_urls.yml").fetch("proxy_urls")
      end.sample
    end
  end
end
