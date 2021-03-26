module ApplicationHelper
  def current_class(path)
    return "current" if current_page?(path)
    ""
  end
end
