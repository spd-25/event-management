class AttendeeStatistic < JsonObjectSerializer

  COLLECTIONS = YAML.load_file(Rails.root.join('config', 'pras.yml'))['collections']

  AGE_RANGES_DEPR = %w[50_65 gt_65].freeze
  AGE_RANGES = %w[unknown lt_16 16_17 18_24 25_34 35_49 50_64 65_75 gt_75].freeze

  attribute :number,       String # deprecated
  attribute :title,        String # deprecated
  attribute :section,      String
  attribute :topic,        Integer
  attribute :event_type,   Integer
  attribute :law_accepted, Boolean, default: true
  attribute :type,         String # deprecated
  attribute :published,    String # deprecated
  attribute :zip,          String
  attribute :location,     String
  attribute :start_date,   String
  attribute :start_time,   String
  attribute :end_date,     String
  attribute :end_time,     String
  attribute :hours,        Integer
  attribute :partner,      String
  attribute :ebg,          Integer, default: 1
  attribute :certificate,  String # deprecated
  attribute :target_group, Integer, default: 9
  attribute :not_local,    Integer, default: 0 # deprecated


  (AGE_RANGES + AGE_RANGES_DEPR).each do |range|
    attribute "age_#{range}_f", Integer, default: 0
    attribute "age_#{range}_m", Integer, default: 0
  end


  def fill_defaults(seminar)
    self.number   = seminar.number         if number.blank?
    self.title    = seminar.title          if title.blank?
    self.location = seminar.location&.name if location.blank?
    events = seminar.events.reload
    return unless events.any?
    first_event     = events.first
    self.start_date = I18n.l(first_event.date) if start_date.blank?
    self.start_time = first_event.start_time   if start_time.blank?
    last_event      = events.last
    self.end_date   = I18n.l(last_event.date)  if end_date.blank?
    self.end_time   = last_event.end_time      if end_time.blank?
  end
end

