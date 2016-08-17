class Seminar < ApplicationRecord
  # belongs_to :teacher, required: true
  # has_and_belongs_to_many :teachers
  # belongs_to :location, required: true

  validates :title, presence: true

  def name
    title
  end
end
