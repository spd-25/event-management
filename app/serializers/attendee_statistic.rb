class AttendeeStatistic < JsonObjectSerializer

  AGE_RANGES = %w(unknown lt_16 16_17 18_24 25_34 35_49 50_65 gt_65)

  attribute :number,       String
  attribute :title,        String
  attribute :section,      String
  attribute :type,         String
  attribute :published,    String
  attribute :location,     String
  attribute :start_date,   String
  attribute :start_time,   String
  attribute :end_date,     String
  attribute :end_time,     String
  attribute :hours,        Integer
  attribute :partner,      String
  attribute :certificate,  String
  attribute :target_group, String, default: '8'
  attribute :not_local,    Integer, default: 0


  AGE_RANGES.each do |range|
    attribute "age_#{range}_f", Integer, default: 0
    attribute "age_#{range}_m", Integer, default: 0
  end


  def fill_defaults(seminar)
    self.number   = seminar.number        unless number.present?
    self.title    = seminar.title         unless title.present?
    self.location = seminar.location.name unless location.present?
    events = seminar.events.order(:date)
    self.start_date = I18n.l(events.first.date) unless start_date.present?
    self.start_time = events.first.start_time   unless start_time.present?
    self.end_date   = I18n.l(events.last.date)  unless end_date.present?
    self.end_time   = events.last.end_time      unless end_time.present?
  end
end

