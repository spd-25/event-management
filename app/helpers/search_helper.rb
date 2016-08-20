module SearchHelper
  def display_name_for(result)
    case result
    when Seminar then [seminars_icon(result.number), result.title]
    when Teacher then [teachers_icon(result.name)]
    when Location then [locations_icon(result.name), result.description]
    when Category then [categories_icon(result.name)]
    end.select(&:present?).join(', ').html_safe
  end
end
