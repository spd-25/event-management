class LegalStatistic < ApplicationRecord

  COLLECTIONS = YAML.load_file(Rails.root.join('config', 'pras.yml'))['collections']

  AGE_RANGES_DEPR = %w[50_65 gt_65].freeze
  AGE_RANGES      = %w[unknown lt_16 16_17 18_24 25_34 35_49 50_64 65_75 gt_75].freeze
  RANGE_FIELDS_F  = AGE_RANGES.map { |range| "age_#{range}_f" }.freeze
  RANGE_FIELDS_M  = AGE_RANGES.map { |range| "age_#{range}_m" }.freeze
  RANGE_FIELDS    = RANGE_FIELDS_F + RANGE_FIELDS_M
  PARTNER_FIELDS  = (1..8).to_a.map { |i| "partner#{i}".to_sym }.freeze

  belongs_to :seminar, inverse_of: :legal_statistic

  delegate :title, :number, to: :seminar

  def fill_defaults
    self.location = seminar.location&.address&.city if location.blank?
    self.zip      = seminar.location&.address&.zip if zip.blank?
    self.law_accepted = false if new_record?
    events = seminar.events.reload
    return unless events.any?
    first_event     = events.first
    self.start_date = I18n.l(first_event.date) if start_date.blank?
    self.start_time = first_event.start_time if start_time.blank?
    last_event      = events.last
    self.end_date   = I18n.l(last_event.date) if end_date.blank?
    self.end_time   = last_event.end_time if end_time.blank?
  end

  def sum_attendees
    RANGE_FIELDS.map { |age| self[age].to_i }.sum(0)
  end

  def attendees_mismatch
    sum_attendees != seminar.attendees.count
  end

  def law_accepted_str
    { true => 'ja', false => 'nein' }[law_accepted]
  end

  def days
    1
  end

  PARTNER_FIELDS.each do |field|
    define_method field do
      'x' if self.class.human_attribute_name(field) == partner
    end
  end

end
