class Seminar < ApplicationRecord
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :categories
  belongs_to :location, optional: true

  validates :number, :title, presence: true

  def name
    title
  end
end
