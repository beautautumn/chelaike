module Download
  module ApplicationHelper
    # user_agent 为空的话, 默认展示iOS的下载
    def user_agent
      @_user_agent ||= request.env["HTTP_USER_AGENT"].try(:downcase)
    end

    def ios?
      user_agent.nil? || user_agent.include?("iphone") || user_agent.include?("ipad")
    end

    def android?
      user_agent.include?("android")
    end

    def wechat?
      user_agent.include?("micromessenger")
    end

    def macos?
      user_agent.include?("mac")
    end

    def ios_link(version)
      "itms-services://?action=download-manifest&url=#{version.plist_source}"
    end

    def qrcode(content)
      api = File.join(ENV.fetch("SERVER_HOST"), "qrcode")
      "#{api}?content=#{content}"
    end
  end
end
