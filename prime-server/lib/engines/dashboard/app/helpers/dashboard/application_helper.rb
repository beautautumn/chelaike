module Dashboard
  module ApplicationHelper

    def toggle_button(options = {})
      url = options.fetch(:url, "javascript:void(0)")
      http_method = options.fetch(:http_method, "GET")
      active = options.fetch(:active, true)
      text = options.fetch(:text) { active ? "是" : "否" }

      button_class = active ? "ui toggle button active" : "ui toggle button"

      button_to url, class: button_class, method: http_method do
        text
      end
    end

     # 重定向到存储的地址或者默认地址
    def redirect_back_or(default, options = {})
      redirect_to session[:forwarding_url] || default,  options
      session.delete(:forwarding_url)
    end

    # 存储后面需要使用的地址
    def store_location
      session[:forwarding_url] = request.original_url if request.get?
    end

  end
end
