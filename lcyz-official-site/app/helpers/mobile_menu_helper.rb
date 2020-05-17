# frozen_string_literal: true
# 移动端底部菜单栏
module MobileMenuHelper
  def mobile_menu
    content_tag :div, class: "weui-tabbar" do
      concat tab_item("home", "home", "首页")
      concat tab_item("cars", "cars", "买车")
      concat tab_item("contact", "contact", "联系")
      concat tab_item("me", "me", "我的")
    end
  end

  def tab_item(controller_name, img_name, alt)
    css_class = ("weui-tabbar__item tab_#{controller_name}" + tab_on(controller_name)).freeze
    link_to send(controller_name + "_path"), class: css_class do
      concat(content_tag(:div, class: "weui-tabbar__icon") do
        img_on img_name, alt
      end)
      concat(content_tag(:p, class: "weui-tabbar__label") do
        alt
      end)
    end
  end

  def tab_on(controller_name)
    controller_name.to_sym == params[:controller].to_sym ? " weui-bar__item_on" : ""
  end

  def img_on(controller_name, alt)
    if controller_name.to_sym == params[:controller].to_sym
      image_tag "mobile/menu/#{controller_name}_on.png", alt: alt
    else
      image_tag "mobile/menu/#{controller_name}.png", alt: alt
    end
  end
end
