class Booking < ApplicationRecord
  belongs_to :seminar
  has_many :attendees
  has_one :invoice

  accepts_nested_attributes_for :attendees, allow_destroy: true

  validates :company_name, :invoice_address, presence: true, if: :company
  validate :validate_attendees

  scope :created,         -> { where.not(id: Invoice.select(:booking_id)) }
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

  private

  def validate_attendees
    errors.add(:attendees, :too_few) if attendees.empty?
  end
end
