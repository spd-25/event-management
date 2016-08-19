class Teacher < ApplicationRecord

  has_and_belongs_to_many :seminars

  validates :last_name, presence: true

  scope :active, -> { where(id: Seminar.joins(:teachers).select('seminars_teachers.teacher_id')) }

  def name
    [title, first_name, last_name].select(&:present?).join(' ')
  end
end
