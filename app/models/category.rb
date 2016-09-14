class Category < ApplicationRecord

  include PgSearch

  belongs_to :category, optional: true, inverse_of: :categories
  has_many :categories, inverse_of: :category
  has_and_belongs_to_many :seminars

  scope :cat_parents, -> { where category_id: nil }

  multisearchable against: [:name]

  def parent?
    category.blank?
  end

  def display_name
    "#{number} #{name}"
  end
end
