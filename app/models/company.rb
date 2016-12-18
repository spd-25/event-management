class Company < ApplicationRecord
  include PgSearch

  validates :name, presence: true

  multisearchable against: [:code, :name, :name2, :city]

end
