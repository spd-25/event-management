class Location < ApplicationRecord

  include PgSearch

  has_many :seminars

  validates :name, presence: true

  multisearchable against: [:name, :description, :address]

end
