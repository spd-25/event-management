class Seminar < ApplicationRecord
  include PgSearch

  belongs_to :catalog, foreign_key: :year, primary_key: :year, inverse_of: :seminars
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :categories
  belongs_to :location, optional: true
  has_many :events, -> { order :date }
  belongs_to :parent,    class_name: 'Seminar', inverse_of: :sub_modules
  has_many :sub_modules, class_name: 'Seminar', inverse_of: :parent, foreign_key: :parent_id
  has_many :bookings
  has_many :attendees, inverse_of: :seminar
  has_many :invoices, inverse_of: :seminar
  belongs_to :original, class_name: 'Seminar', foreign_key: 'copy_from_id', inverse_of: :copies
  has_many :copies,     class_name: 'Seminar', foreign_key: 'copy_from_id', inverse_of: :original

  accepts_nested_attributes_for :events,
                                allow_destroy: true,
                                reject_if: -> (attr) { attr['date'].blank? }

  serialize :statistic, ::AttendeeStatistic

  validates :number, :title, presence: true
  validates :number, uniqueness: true
  # validate :validate_events

  after_save :set_date

  default_scope { where archived: false }

  scope :published, -> { where published: true }
  scope :canceled,  -> { where canceled:  true }
  scope :bookable,  -> { where 'date >= :date', date: Date.current }
  scope :by_month, lambda { |month|
    (
    if month.zero?
      where(date: nil)
    else
      where('extract(month from date) = ?', month)
    end)
  }

  has_paper_trail

  multisearchable against: %i(number title subtitle benefit content notes due_date price_text key_words)
  pg_search_scope :external_search,
                  against: %i(number title subtitle benefit content notes due_date price_text key_words),
                  associated_against: {
                    teachers: %i(first_name last_name profession),
                    categories: %i(name),
                    location: %i(name description address)
                  }

  def name
    title
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    I18n.transliterate(name.downcase).delete('"').gsub(/[^a-z0-9]+/, '-')
  end

  def bookable?
    (date || Date.current) >= Date.current
  end

  private

  def validate_events
    errors.add(:events, :too_few) if events.empty?
  end

  def set_date
    return unless events.any?
    update_column :date, events.order(:date).first.date
  end
end
