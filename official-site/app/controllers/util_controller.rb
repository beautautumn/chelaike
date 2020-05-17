# frozen_string_literal: true
class UtilController < ApplicationController
  skip_before_action :current_tenant

  # 测试服务器是否工作正常
  def test
    Rails.logger.silence do
      render text: "ok"
    end
  end

  # 无效租户
  def invalid_tenant; end
end
