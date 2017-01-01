class Company < ApplicationRecord
  include PgSearch

  has_many :bookings, inverse_of: :company

  validates :name, presence: true

  multisearchable against: [:code, :name, :name2, :city]

  def address
    "#{street}\n#{zip} #{city}\n#{city_part}"
  end

  def full_address
    "#{name}\n#{address}"
  end

end
