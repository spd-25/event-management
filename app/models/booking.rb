class Booking < ApplicationRecord
  belongs_to :seminar
  has_many :attendees
  has_one :invoice

  accepts_nested_attributes_for :attendees,
                                allow_destroy: true,
                                reject_if: lambda { |attributes|
                                  attributes['first_name'].blank? || attributes['last_name'].blank?
                                }

  scope :created,         -> { where.not(id: Invoice.select(:booking_id)) }
  scope :invoice_created, -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:created]) }
  scope :invoice_sent,    -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:sent]) }
  scope :invoice_payed,   -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:payed]) }

  def name
    ''
  end
end
