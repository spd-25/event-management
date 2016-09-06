class Teacher < ApplicationRecord

  include PgSearch

  has_and_belongs_to_many :seminars

  validates :last_name, presence: true

  acts_as_addressable
  acts_as_contactable

  multisearchable against: [:title, :first_name, :last_name, :profession]

  def name
    [title, first_name, last_name].select(&:present?).join(' ')
  end
end
