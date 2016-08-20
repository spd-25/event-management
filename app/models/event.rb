class Event < ApplicationRecord
  belongs_to :seminar
  belongs_to :location, optional: true

  validates :date, presence: true

end
