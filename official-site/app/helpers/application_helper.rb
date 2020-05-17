# frozen_string_literal: true
module ApplicationHelper
  def nav_active(current_path, path)
    return " class=active" if current_path.include? path
    return " class=active" if current_path == "/" && path == home_path
  end

  def truncate_string(str, size)
    if str && str.size > size
      return str[0, size] + "..."
    end
    str
  end
end
