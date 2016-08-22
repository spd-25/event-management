class Location < ApplicationRecord

  include PgSearch

  has_many :seminars

  validates :name, presence: true

  acts_as_addressable

  multisearchable against: [:name, :description, :address]

end
