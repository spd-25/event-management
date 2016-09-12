module SeminarsHelper
  def css_class_for(record)
    case record
    when Seminar
      return '' if record.bookings.empty?
      return 'open' if record.open_bookings.any?
      record.bookings.includes(:invoice).map(&:invoice).all?(&:payed?) ? 'payed' : 'pending'
    when Booking
      return 'open' if record.invoice.blank?
      record.invoice.payed? ? 'payed' : 'pending'
    end
  end

  def progress_bar_for_bookings(seminar)
    count           = seminar.bookings.count
    open_count      = seminar.open_bookings.count
    payed_count     = seminar.payed_bookings.count
    pending_count   = count - open_count - payed_count

    open_percent    = (100 * open_count / count).to_i
    payed_percent   = (100 * payed_count / count).to_i
    pending_percent = 100 - open_percent - payed_percent

    title = "Anmeldungen: #{open_count} offen, #{pending_count} Rechnung erstellt, #{payed_count} bezahlt"
    content_tag :div, class: 'progress', title: title do
      content_tag(:div, payed_count, class: 'progress-bar progress-bar-success', style: "width: #{payed_percent}%") +
        content_tag(:div, pending_count, class: 'progress-bar progress-bar-warning', style: "width: #{pending_percent}%") +
        content_tag(:div, open_count, class: 'progress-bar progress-bar-danger', style: "width: #{open_percent}%")
    end
  end
end
