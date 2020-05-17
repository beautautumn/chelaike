# frozen_string_literal: true
module MeHelper
  def slide_bar_action_menu(name, path)
    if request.path == path
      name
    else
      link_to name, path
    end
  end
end
