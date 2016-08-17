class Seminar < ApplicationRecord
  has_and_belongs_to_many :teachers
  belongs_to :location, optional: true

  validates :title, presence: true

  def name
    title
  end
end
