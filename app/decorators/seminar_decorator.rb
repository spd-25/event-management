class SeminarDecorator < ApplicationDecorator
  delegate_all

  def events_list
    @events_list ||= EventsList.new events
  end

  def formatted_events(separator: '; ')
    events_list.map { |dates, time| "#{h.ldate(dates)} (#{time})" }.join separator
  end

  def dates
    events_list.map { |date, _| h.ldate date }
  end

  def has_date_text?
    h.strip_tags(object.date_text || '').present?
  end

  def stripped_date_text
    h.strip_tags(object.date_text.gsub('<br>', "\n"))
  end

  def date_text_or_events
    has_date_text? ? stripped_date_text : formatted_events
  end

  def editing_finished?
    editing_finished_at.present?
  end

  def layout_finished?
    layout_finished_at.present?
  end

  def can_finish_layout?
    !layout_finished? && editing_finished?
  end
end
