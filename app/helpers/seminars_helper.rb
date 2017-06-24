module SeminarsHelper
  def events_list(seminar)
    seminar.events_list.map { |dates, time| "#{ldate(dates)} (#{time})" }
  end
end
