class Booking < ApplicationRecord
  belongs_to :seminar
  has_many :attendees

  accepts_nested_attributes_for :attendees,
                                allow_destroy: true,
                                reject_if: lambda { |attributes|
                                  attributes['first_name'].blank? || attributes['last_name'].blank?
                                }

  acts_as_addressable field_name: :invoice_address

  def name
    ''
  end
end
