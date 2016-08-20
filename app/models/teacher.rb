class Teacher < ApplicationRecord

  include PgSearch

  has_and_belongs_to_many :seminars

  validates :last_name, presence: true

  scope :active, -> { where(id: Seminar.joins(:teachers).select('seminars_teachers.teacher_id')) }

  multisearchable against: [:title, :first_name, :last_name, :profession]

  def name
    [title, first_name, last_name].select(&:present?).join(' ')
  end
end
