module Util
  class RongPush
    attr_accessor :platform

    def initialize(from_user_id, to_user_ids, content, platform = :default)
      @platform = platform
      ::Rongcloud::Configure.load_config(platform) do
        @client = ::Rongcloud::Message.new(
          from_user_id: from_user_id,
          to_user_id: to_user_ids,
          object_name: :text,
          content: content,
          push_content: content_title(content),
          push_data: push_data(content)
        )
      end
    end

    # 发送系统消息通道
    def send
      result = nil
      ::Rongcloud::Configure.load_config(@platform) do
        result = @client.system_publish
      end
      result
    end

    # 发送单聊信息通道
    def private_send
      result = nil
      ::Rongcloud::Configure.load_config(@platform) do
        result = @client.private_send
      end
      result
    end

    private

    # 先保留，等ios一起调试
    def content_title(content)
      content.fetch(:content, "")
    end

    def push_data(content)
      content.fetch(:extra, "")
    end
  end
end
