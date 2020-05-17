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

    def ios_link(version, app_alias)
      if app_alias == "chelaike"
        "https://itunes.apple.com/cn/app/%E8%BD%A6%E6%9D%A5%E5%AE%A2/id1317190414?mt=8"
      elsif ["market", "market-shop" "bm"].include?(app_alias)
        # 当市场版或帮卖版时，直接指向蒲公英最新版
        version.ios_source
      else
        "itms-services://?action=download-manifest&url=#{version.plist_source}"
      end
    end

    def qrcode(content)
      api = File.join(ENV.fetch("SERVER_HOST"), "qrcode")
      "#{api}?content=#{content}"
    end
  end
end
