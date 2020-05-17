# frozen_string_literal: true
class ApplicationDecorator < Draper::Decorator
  def domain
    case Rails.env
    when "production"
      "site.chelaike.com"
    else
      "lina-site.chelaike.com"
    end
  end
end
