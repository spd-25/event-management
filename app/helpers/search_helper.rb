module SearchHelper
  def display_name_for(result)
    case result
    when Seminar then [icon_for(result, text: result.number), result.title]
    when Teacher then [icon_for(result, text: result.name)]
    when Location then [icon_for(result, text: result.name), result.description]
    when Category then [icon_for(result, text: result.name)]
    end.select(&:present?).join(', ').html_safe
  end
end
