class Category < ApplicationRecord

  include PgSearch

  belongs_to :category, optional: true
  has_many :categories
  has_and_belongs_to_many :seminars

  scope :cat_parents, -> { where category_id: nil }

  multisearchable against: [:name]

  def parent?
    category.blank?
  end
end
