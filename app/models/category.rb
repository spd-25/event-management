class Category < ApplicationRecord

  include PgSearch

  validates :year, presence: true

  belongs_to :catalog, foreign_key: :year, primary_key: :year, inverse_of: :categories
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

  def all_seminars
    Seminar.where(id: seminars).or seminars_for_sub_categories
  end

  def seminars_for_sub_categories
    Seminar.where(id: categories.joins(:seminars).select(:seminar_id))
  end
  #
  # def self.seminars_count
  #   res = {}
  #   Seminar.joins(:categories).group('categories.category_id', 'categories.id').count.each do |(parent, cat), count|
  #     if parent.nil?
  #       res[cat] = count
  #     else
  #       res[parent] ||= {}
  #       res[parent][cat] = count
  #     end
  #   end
  #   res
  # end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    s = I18n.transliterate(name.downcase).gsub(/"/, '').gsub(/[^a-z0-9]+/, '-')
    n = number.gsub(' ', '')
    # n = "#{category.number}.#{n}" if category.present?
    "#{n}-#{s}"
  end

end
