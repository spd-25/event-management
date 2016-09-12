class Booking < ApplicationRecord
  belongs_to :seminar
  has_many :attendees
  belongs_to :invoice, inverse_of: :booking

  accepts_nested_attributes_for :attendees, allow_destroy: true

  validates :company_name, :invoice_address, presence: true, if: :company
  validate :validate_attendees

  scope :created,         -> { where(invoice_id: nil) }
  scope :invoice_created, -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:created]) }
  scope :invoice_sent,    -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:sent]) }
  scope :invoice_payed,   -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:payed]) }

  def name
    if company
      company_name
    else
      attendee = attendees.first
      "#{attendee.first_name} #{attendee.last_name}"
    end
  end

  def generate_invoice
    address = company ? company_address : attendees.first.full_address
    items = attendees.map{ |attendee| { attendee: attendee.name, price: 23.87 } }
    build_invoice number: Invoice.next_number, date: Date.current, address: address, items: items
  end

  def company_address
    "#{company_name}\n#{invoice_address}"
  end
  
  private

  def validate_attendees
    errors.add(:attendees, :too_few) if attendees.empty?
  end
end
