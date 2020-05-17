# frozen_string_literal: true
class ContactController < ApplicationController
  change_view_by_device

  def index
    @company = @tenant.company
  end
end
