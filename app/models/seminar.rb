class Seminar < ApplicationRecord
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :categories
  belongs_to :location, optional: true
  has_many :events

  accepts_nested_attributes_for :events,
                                allow_destroy: true,
                                reject_if: lambda { |attr| attr['date'].blank? }

  validates :number, :title, presence: true
  # validate :validate_events

  def name
    title
  end

  private

  def validate_events
    errors.add(:events, :too_few) if events.empty?
  end
end
