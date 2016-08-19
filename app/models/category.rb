class Category < ApplicationRecord
  belongs_to :category, optional: true
  has_many :categories
  has_and_belongs_to_many :seminars

  scope :cat_parents, -> { where category_id: nil }

  def parent?
    category.blank?
  end
end
