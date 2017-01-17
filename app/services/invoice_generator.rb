class InvoiceGenerator
  attr_reader :attendee, :company, :seminar

  def initialize(attendee: nil, company: nil, seminar: nil)
    raise ArgumentError, 'Attendee or company and seminar must be given' unless attendee.present? || [company, seminar].all?(&:present?)
    @attendee = attendee
    @company = company
    @seminar = @attendee.present? ? @attendee.seminar : seminar
  end

  def invoice
    Invoice.new number: Invoice.next_number, date: Date.current, address: address, items: items,
                seminar: seminar, attendees: attendees, company: company,
                pre_message: message(:pre), post_message: message(:post)
  end

  private

  def attendees
    attendee ? [attendee] : seminar.attendees.where(company: company)
  end

  def items
    attendees.map { |attendee| { attendee: attendee.name, price: seminar.price || 0 } }
  end

  def address
    (attendee&.invoice_address || company).full_address
  end

  def message(pos)
    I18n.t("invoices.default_#{pos}_message")
  end
end
