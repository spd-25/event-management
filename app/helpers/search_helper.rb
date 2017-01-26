module SearchHelper
  def display_name_for(result)
    case result
    when Seminar  then [icon_for(result, text: result.number), result.title]
    when Teacher  then [icon_for(result, text: result.name)]
    when Location then [icon_for(result, text: result.name), result.description]
    when Category then [icon_for(result, text: result.name)]
    when Company  then [icon_for(result, text: result.name), result.city, "#{result.attendees.booked.count} Anmeldungen"]
    when Attendee then [icon_for(result, text: result.name), result.booking.seminar.title]
    end.select(&:present?).join(', ').html_safe
  end

  def search_col_width(group_count)
    return 2 if group_count > 4
    12 / group_count
  end
end
