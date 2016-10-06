class Attendee < ApplicationRecord
  belongs_to :seminar
  belongs_to :booking

  acts_as_addressable
  acts_as_contactable

  validates :first_name, :last_name, presence: true

  has_paper_trail

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    [name, address.street, "#{address.zip} #{address.city}"].join("\n")
  end
end
