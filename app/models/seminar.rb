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
  has_many :attendees, -> { booked }, inverse_of: :seminar
  has_many :all_attendees, class_name: 'Attendee'
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
    month.zero? ? where(date: nil) : where('extract(month from date) = ?', month)
  }
  scope :editing_finished,     -> { where.not editing_finished_at: nil }
  scope :editing_not_finished, -> { where     editing_finished_at: nil }
  scope :layout_finished,      -> { where.not layout_finished_at:  nil }
  scope :layout_not_finished,  -> { where     layout_finished_at:  nil }

  scope :layout_open,          -> { editing_finished.layout_not_finished }
  scope :all_finished,         -> { editing_finished.layout_finished }
  scope :completed,            -> { all_finished.where('editing_finished_at < layout_finished_at') }
  scope :layout_changed,       -> { all_finished.where('editing_finished_at > layout_finished_at') }


  has_paper_trail

  search_fields = %i(number title subtitle benefit content notes due_date price_text key_words)
  associated_fields = {
    teachers:   %i(first_name last_name profession),
    categories: %i(name),
    location:   %i(name description address)
  }
  multisearchable against: search_fields
  pg_search_scope :external_search, against: search_fields, associated_against: associated_fields

  def cache_key
    [super, bookable?].join '/'
  end

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

  def finish_editing!
    update editing_finished_at: DateTime.current
  end

  def finish_layout!
    update layout_finished_at: DateTime.current
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
