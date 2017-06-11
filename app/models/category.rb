class Category < ApplicationRecord

  include PgSearch

  validates :name, :year, presence: true
  validates :position, uniqueness: { scope: [:year, :parent_id] }
  validate :acyclic_graph

  belongs_to :catalog, foreign_key: :year, primary_key: :year, inverse_of: :categories
  has_and_belongs_to_many :seminars

  # old version
  # belongs_to :category, optional: true, inverse_of: :categories
  # has_many :categories, inverse_of: :category
  # scope :cat_parents, -> { where category_id: nil }

  # new version
  belongs_to :parent, class_name: 'Category', inverse_of: :children
  has_many :children, -> { order :position }, class_name: 'Category', foreign_key: 'parent_id', inverse_of: :parent
  scope :roots, -> { where(parent_id: nil).order(:position) }

  has_paper_trail ignore: [:position]

  multisearchable against: [:name]

  # def parent?
  #   category.blank?
  # end

  def root?
    parent.blank?
  end

  def display_name
    # "#{number} #{name}"
    [number, name].select(&:present?).join(' ')
  end

  def all_seminars
    Seminar.where id: descendants.flat_map(&:seminar_ids)
  end

  def seminars_count
    @seminars_count ||= all_seminars.count
  end

  # def seminars_for_sub_categories
  #   Seminar.where(id: categories.joins(:seminars).select(:seminar_id))
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

  # returns an array of nav entries reflecting the path from the root to this entry
  def path
    (parent&.path || []) + [ self ]
  end

  # returns an array of all children's children including the nav entry itself
  def descendants
    [self] + children.includes(:children).flat_map(&:descendants)
  end

  def move(direction)
    case direction.to_sym
    when :up    then swap_position_with predecessor
    when :down  then swap_position_with successor
    when :left  then set_parent_to parent&.parent&.id
    when :right then predecessor && set_parent_to(predecessor.id)
    else raise 'unknown direction'
    end
  end

  def calculate_position
    self.position = self.class.next_position_for year, parent_id
  end

  private

  def self.next_position_for(year, parent_id)
    (where(year: year, parent_id: parent_id).maximum(:position) || 0) + 1
  end

  def successor
    siblings.where('position > ?', position).order(:position).first
  end

  def predecessor
    siblings.where('position < ?', position).order(position: :desc).first
  end

  def siblings
    self.class.where(parent_id: parent_id)
  end

  def swap_position_with(other)
    return unless other
    new_position = other.position
    old_position = position
    self.class.transaction do
      other.update! position: 9999
      update! position: new_position
      other.update! position: old_position
    end
  end

  def set_parent_to(new_parent_id)
    position = self.class.next_position_for year, new_parent_id
    update! parent_id: new_parent_id, position: position
  end

  def acyclic_graph
    errors.add(:parent, 'could not be one of the descendants') if parent.in? descendants
  end
end
