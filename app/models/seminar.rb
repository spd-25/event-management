class Seminar < ApplicationRecord
  include PgSearch

  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :categories
  belongs_to :location, optional: true
  has_many :events
  has_many :bookings
  has_many :attendees, through: :bookings

  accepts_nested_attributes_for :events,
                                allow_destroy: true,
                                reject_if: lambda { |attr| attr['date'].blank? }

  validates :number, :title, presence: true
  validates :number, uniqueness: true
  # validate :validate_events

  multisearchable against: [:number, :title, :subtitle, :benefit, :content, :notes, :due_date, :price_text]

  def name
    title
  end

  def grouped_categories
    parent_categories.each_with_object({}) do |parent, res|
      res[parent] = categories.to_a.find_all { |cat| cat.category == parent }
    end
  end

  def parent_categories
    (categories.select(&:parent?) + categories.map(&:category)).compact.uniq.sort_by(&:name)
  end

  private

  def validate_events
    errors.add(:events, :too_few) if events.empty?
  end
end
