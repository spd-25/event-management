class Category < ApplicationRecord

  include PgSearch

  belongs_to :category, optional: true, inverse_of: :categories
  has_many :categories, inverse_of: :category
  has_and_belongs_to_many :seminars

  scope :cat_parents, -> { where category_id: nil }

  has_paper_trail

  multisearchable against: [:name]

  def parent?
    category.blank?
  end

  def display_name
    "#{number} #{name}"
  end

  def self.seminars_count
    res = {}
    Seminar.joins(:categories).group('categories.category_id', 'categories.id').count.each do |(parent, cat), count|
      if parent.nil?
        res[cat] = count
      else
        res[parent] ||= {}
        res[parent][cat] = count
      end
    end
    res
  end
end
