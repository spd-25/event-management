class EventsList
  include Enumerable

  attr_reader :events

  def initialize(events)
    @events = events
  end

  def grouped
    @grouped_events ||= calculate_grouped_events.map do |(_first, time), dates|
      first = dates.size == 1 ? dates.first : dates.first..dates.last
      [first, time]
    end.to_h
  end

  def each(&block)
    grouped.each(&block)
  end

  private

  def calculate_grouped_events
    range_start   = nil
    previous_date = nil
    events.each_with_object(Hash.new { [] }) do |event, res|
      next unless event.date.is_a? Date
      date          = event.date
      time          = event.time
      range_start   = date if [date.yesterday, time] != previous_date
      previous_date = [date, time]
      res[[range_start, time]] += [date]
    end
  end
end
