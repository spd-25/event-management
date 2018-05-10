class Booking < ApplicationRecord
  enum status: { created: 0, canceled: 1 }

  attr_accessor :external

  belongs_to :seminar
  has_many :attendees
  # belongs_to :invoice, inverse_of: :booking
  belongs_to :company #, inverse_of: :bookings, optional: true

  acts_as_addressable field_name: :invoice_address, prefix: :invoice
  acts_as_addressable field_name: :company_address, prefix: :company
  acts_as_contactable
  accepts_nested_attributes_for :attendees, allow_destroy: true

  validate :validate_attendees
  validates :data_protection, acceptance: true
  validates :terms_of_service, acceptance: true
  validates :contact_email, :contact_phone, presence: true, if: :external
  validates :invoice_title, :invoice_street, :invoice_zip, :invoice_city, presence: true, if: :external

  # scope :created,         -> { where(invoice_id: nil) }
  # scope :invoice_created, -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:created]) }
  # scope :invoice_sent,    -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:sent]) }
  # scope :invoice_payed,   -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:payed]) }

  has_paper_trail

  def name
    ''
  end

  # def generate_invoice
  #   address = (company || invoice_address).full_address
  #   items = attendees.map { |attendee| { attendee: attendee.name, price: seminar.price || 0 } }
  #   build_invoice number: Invoice.next_number, date: Date.current, address: address, items: items,
  #       pre_message:  I18n.t('invoices.default_pre_message'),
  #       post_message: I18n.t('invoices.default_post_message')
  # end

  private

  def validate_attendees
    errors.add(:attendees, :too_few) if attendees.empty?
  end
end
