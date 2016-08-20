class Event < ApplicationRecord
  belongs_to :seminar, optional: true
  belongs_to :location, optional: true

  # validates :date, presence: true

end
