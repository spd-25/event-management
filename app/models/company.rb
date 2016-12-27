class Company < ApplicationRecord
  include PgSearch

  has_many :bookings, inverse_of: :company

  validates :name, presence: true

  multisearchable against: [:code, :name, :name2, :city]

end
