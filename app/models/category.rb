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

  def all_seminars
    category_ids = [id] + categories.pluck(:id)
    Seminar.joins(:categories).where('categories.id' => category_ids)
  end

  def display_name(with_number: true, with_counts: true)
    res = name
    res = "#{number} #{res}" if with_number
    res = "#{res} (#{all_seminars.count})" if with_counts
    res
  end
end
