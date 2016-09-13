require 'csv'

module Importer2017

  def self.import
    create_categories_from_csv
    read_seminars_from_csv.values.map { |seminar| create_seminar seminar }
  end

  def self.create_seminar(sem_hash)
    title           = sem_hash[:title]
    subtitle        = ''
    titles          = title.split(' - ')
    title, subtitle = titles if titles.size == 2

    sem = {
      number:            sem_hash[:number],
      title:             title,
      subtitle:          subtitle,
      year:              2017,
      price_text:        sem_hash['price'],
      events_attributes: event_attributes(sem_hash),
      categories:        Category.where(name: sem_hash[:categories]),
      teachers:          teachers(sem_hash)
    }
    Seminar.create! sem
  end

  def self.event_attributes(seminar)
    res = []
    # res << { start_time: start_time, end_time: end_time, notes: end_date, location_id: location_id }
    res
  end

  def self.teachers(seminar)
    return [] if seminar[:teacher].blank?
    seminar[:teacher].split(';').map do |teacher_name|
      Teacher.find_or_create_by last_name: teacher_name.strip
    end
  end

  def self.create_categories_from_csv
    parent = nil
    CSV.foreach Rails.root.join('db/seeds/seminars-2017.csv'), quote_char: "'", headers: true do |row|
      name = strip_category_title row['title']
      case type_of(row)
      when :parent then parent = Category.find_or_create_by! name: name
      when :sub    then Category.find_or_create_by! name: name, category: parent
      end
    end
  end

  def self.read_seminars_from_csv
    seminars = {}
    category = ''
    CSV.foreach Rails.root.join('db/seeds/seminars-2017.csv'), quote_char: "'", headers: true do |row|
      case type_of(row)
      when :parent, :sub then category = strip_category_title row['title']
      when :seminar then
        number = row['number']
        seminars[number] = row.to_h.symbolize_keys.merge(categories: []) if seminars[number].nil?
        seminars[number][:categories] << category
      end
    end
    seminars
  end

  def self.strip_category_title(title)
    title.gsub('neuer Titel', '').strip
  end

  def self.type_of(row)
    return :seminar if row['number'].present?
    first = row['title'].split(' - ', 2).first
    return :parent if first.in?(%w(I II III IV V VI VII))
    return :sub if first.to_i > 0
    puts "unknown category type #{row['title']}"
  end

  def self.reset(*models)
    models.each do |model|
      model.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
    end
  end

end
