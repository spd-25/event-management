class LegalStatistic < ApplicationRecord

  COLLECTIONS = YAML.load_file(Rails.root.join('config', 'pras.yml'))['collections']

  AGE_RANGES_DEPR = %w[50_65 gt_65].freeze
  AGE_RANGES      = %w[unknown lt_16 16_17 18_24 25_34 35_49 50_64 65_75 gt_75].freeze

  belongs_to :seminar, inverse_of: :legal_statistic

  def fill_defaults
    # self.number   = seminar.number         if number.blank?
    # self.title    = seminar.title          if title.blank?
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

end
