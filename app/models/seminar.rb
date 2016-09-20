class Seminar < ApplicationRecord
  include PgSearch

  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :categories
  belongs_to :location, optional: true
  has_many :events
  has_many :bookings
  has_many :open_bookings,  -> { where(invoice_id: nil) }, class_name: 'Booking'
  has_many :payed_bookings, -> { joins(:invoice).where('invoices.status' => Invoice.statuses[:payed]) }, class_name: 'Booking'
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

  def dates
    _dates = events.map(&:date).compact.sort
    start_date = nil
    _dates.each_with_object({}) do |date, res|
      start_date      = date unless date.yesterday.in? _dates
      res[start_date] = date
    end.map do |start_date, end_date|
      start_date == end_date ? start_date : (start_date..end_date)
    end
  end

  private

  def validate_events
    errors.add(:events, :too_few) if events.empty?
  end
end
