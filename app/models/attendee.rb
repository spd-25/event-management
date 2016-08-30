class Attendee < ApplicationRecord
  belongs_to :seminar
  belongs_to :booking

  acts_as_addressable
  acts_as_contactable

  validates :first_name, :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

end
