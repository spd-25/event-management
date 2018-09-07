class Booking < ApplicationRecord
  enum status: { created: 0, canceled: 1 }

  attr_accessor :external

  belongs_to :seminar
  has_many :attendees
  belongs_to :company

  acts_as_addressable field_name: :invoice_address, prefix: :invoice
  acts_as_addressable field_name: :company_address, prefix: :company
  acts_as_contactable
  accepts_nested_attributes_for :attendees, allow_destroy: true

  validate :validate_attendees
  validates :data_protection, acceptance: true
  validates :terms_of_service, acceptance: true
  validates :contact_email, :contact_phone, presence: true, if: :external
  validates :invoice_title, :invoice_street, :invoice_zip, :invoice_city, presence: true, if: :external

  before_save { |booking| booking.graduate = booking.reduction.to_s == 'school' }

  has_paper_trail

  def name
    ''
  end

  private

  def validate_attendees
    errors.add(:attendees, :too_few) if attendees.empty?
  end
end
