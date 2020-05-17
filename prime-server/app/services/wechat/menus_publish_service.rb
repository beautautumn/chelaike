module Wechat
  class MenusPublishService
    ButtonTypeAdapter = { "msg" => "click", "url" => "view" }.freeze

    def initialize(wechat_app, state)
      @wechat_app = wechat_app
      @state = state
      @event = []
    end

    def execute
      @wechat_app.update!(menus_state: @state) if @state.present?
      return unless @state == "published"
      sync_menu!
      create_wechat_messages!
    end

    private

    def sync_menu!
      Wechat::Mp::Menu.update(@wechat_app.app_id, transform_menu)
    end

    def transform_menu
      wechat_button = @wechat_app.menus.map do |button|
        item = { "name" => button["name"] }
        if button["cate"] == "group"
          sub = button["children"].map do |children|
            transform_button(children).merge(
              "name" => children["name"]
            )
          end
          item.merge("sub_button" => sub)
        else
          transform_button(button).merge(item)
        end
      end
      { "button" => wechat_button }
    end

    def event_key(name)
      name.to_s
    end

    def transform_button(button)
      type = ButtonTypeAdapter.fetch(button["cate"], button["cate"])
      case type
      when "view"
        {
          "type" => "view",
          "url" => button["url"]
        }
      when "click"
        key = event_key(button["name"])
        @event << { key: key, content: button["message"] }
        {
          "type" => "click",
          "key" => key
        }
      end
    end

    # 目前默认text
    def create_wechat_messages!
      WechatMessage.transaction do
        @wechat_app.wechat_messages.delete_all
        @event.each do |e|
          WechatMessage.create!(
            app_id: @wechat_app.app_id,
            key: e[:key],
            message_type: "text",
            content: { content: e[:content] }
          )
        end
      end
    end
  end
end
