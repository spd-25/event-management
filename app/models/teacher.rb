class Teacher < ApplicationRecord

  has_and_belongs_to_many :seminars

  validates :last_name, presence: true

  def name
    [title, first_name, last_name].join(' ')
  end
end
