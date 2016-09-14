require 'csv'

module Importer2017

  def self.import
    ActiveRecord::Base.logger.level = 1
    reset Seminar, Category, Location, Teacher
    import_seminars
    import_categories
    import_categories_seminars
    ActiveRecord::Base.logger.level = 0
  end

  def self.import_categories
    print '  categories ... '
    CSV.foreach Rails.root.join('db/seeds/categories-2017.csv'), headers: true do |row|
      parent = Category.find_or_create_by! name: row['category']
      Category.create!(name: row['subcategory'], category: parent) if row['subcategory'].present?
    end
    puts Category.count
  end

  def self.import_seminars
    print '  seminars ... '
    errors = []
    CSV.foreach Rails.root.join('db/seeds/seminars-2017.csv'), quote_char: "'", headers: true do |row|
      begin
        create_seminar row
      rescue ActiveRecord::RecordInvalid => e
        errors << [e.class, row.to_h, e.record.errors.to_h]
      rescue StandardError => e
        errors << [e.class, row.to_h]
      end
    end
    puts Seminar.count
    puts 'Errors:', errors if errors.any?
  end

  def self.import_categories_seminars
    puts 'link categories and seminars'
    CSV.foreach Rails.root.join('db/seeds/categories-seminars-2017.csv'), quote_char: "'", headers: true do |row|
      # 'seminar','category'
      begin
        seminar = Seminar.find_by! number: row['seminar']
        category = Category.find_by! name: row['category']
        seminar.categories << category
      rescue ActiveRecord::RecordNotFound
        puts row.to_h
      end
    end
  end

  def self.create_seminar(row)
    # title number date time location teachers price price_text
    sem_hash = row.to_h.symbolize_keys
    title    = sem_hash[:title]
    subtitle = ''
    if title.include?(' - ')
      titles   = title.rpartition(' - ')
      title    = titles.first
      subtitle = titles.last
    end

    sem = sem_hash.slice(:number, :price, :price_text).merge(
      title:             title,
      subtitle:          subtitle,
      year:              2017,
      events_attributes: event_attributes(sem_hash),
      teachers:          teachers(sem_hash[:teachers])
    )
    if sem_hash[:location].present?
      sem[:location] = Location.find_or_create_by!(name: sem_hash[:location])
    end
    Seminar.create! sem
  end

  def self.event_attributes(seminar)
    date_error = false
    dates = begin
      seminar[:date].split(';').map do |date|
        next if date.strip.blank?
        start, end_date = date.split('-').map(&:strip)
        if end_date.present?
          end_date = Date.parse end_date
          start = Date.new end_date.year, end_date.month, start.to_i
          (start..end_date).to_a
        else
          Date.parse start
        end
      end.flatten
    rescue StandardError
      date_error = true
      [nil]
    end

    times = seminar[:time].to_s.split(';').map(&:strip)

    res = []
    dates.each_with_index do |date, index|
      i = (dates.size == times.size) ? index : 0
      start_time, end_time = times[i].to_s.split('-').map(&:strip)
      event = { date: date, start_time: start_time, end_time: end_time }
      event[:notes] = seminar[:date] if date_error
      res << event
    end
    res
  end

  def self.teachers(teachers)
    return [] if teachers.blank?
    teachers.split(';').map { |teacher| Teacher.find_or_create_by last_name: teacher.strip }
  end

  # def self.create_categories_from_csv
  #   parent = nil
  #   CSV.foreach Rails.root.join('db/seeds/seminars-2017.csv'), quote_char: "'", headers: true do |row|
  #     name = strip_category_title row['title']
  #     case type_of(row)
  #     when :parent then parent = Category.find_or_create_by! name: name
  #     when :sub    then Category.find_or_create_by! name: name, category: parent
  #     end
  #   end
  # end
  #
  # def self.read_seminars_from_csv
  #   seminars = {}
  #   category = ''
  #   CSV.foreach Rails.root.join('db/seeds/seminars-2017.csv'), quote_char: "'", headers: true do |row|
  #     case type_of(row)
  #     when :parent, :sub then category = strip_category_title row['title']
  #     when :seminar then
  #       number = row['number']
  #       seminars[number] = row.to_h.symbolize_keys.merge(categories: []) if seminars[number].nil?
  #       seminars[number][:categories] << category
  #     end
  #   end
  #   seminars
  # end
  #
  # def self.strip_category_title(title)
  #   title.gsub('neuer Titel', '').strip
  # end
  #
  # def self.type_of(row)
  #   return :seminar if row['number'].present?
  #   first = row['title'].split(' - ', 2).first
  #   return :parent if first.in?(%w(I II III IV V VI VII))
  #   return :sub if first.to_i > 0
  #   puts "unknown category type #{row['title']}"
  # end

  def self.reset(*models)
    models.each do |model|
      model.destroy_all
      ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
    end
  end

end
