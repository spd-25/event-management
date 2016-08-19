class Location < ApplicationRecord

  has_many :seminars

  validates :name, presence: true
end
