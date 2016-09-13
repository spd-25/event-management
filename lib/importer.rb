module Importer

  class PageImport

    attr_reader :doc, :data

    def initialize(file_name)
      @file_name = file_name
      @doc = Nokogiri::HTML(File.open(file_name), nil, 'UTF-8')
    end

    def input(name)
      doc.css("input[name=#{name}]")&.attribute('value')&.value
    end

    def select(name)
      selected = doc.css("select[name=#{name}]>option[selected]")
      selected.attribute('value')&.value
    rescue NoMethodError => e
      nil
    end

    def checkbox(name)
      val = doc.css("input[type=checkbox][name=#{name}]")&.attribute('value')&.value
      return nil if val.nil?
      val == '1'
    end

    def textarea(name)
      doc.css("textarea[name=#{name}]").inner_html
    end
  end

  class SeminarPage < PageImport
    def to_h
      {
        year:              2016,
        id:                input('id'),
        title:             input('titel'),
        subtitle:          input('untertitel'),
        number:            input('seminarnr0'),
        category_ids:      category_ids,
        teacher_ids:       teacher_ids,
        location_id:       select('ort0'),
        benefit:           textarea('nutzen'),
        content:           textarea('inhalt'),
        notes:             textarea('bemerkungen'),
        price_text:        textarea('gebuehr'),
        due_date:          textarea('anmeldeschluss'),
        events_attributes: event_attributes,
        others:            others,
      }
    end

    def teacher_ids
      (0...input('refs').to_i).map { |i| select("referent#{i}") }.uniq
    end

    def category_ids
      (0...input('themen').to_i).map { |i| select("thema#{i}") }.uniq
    end

    def event_attributes
      count_dates = input('termine').to_i
      res = []
      start_time          = input('zeitvon')
      end_time            = input('zeitbis')
      (0...count_dates).each do |i|
        location_id = select("ort#{i}")
        start_date  = input("datumvon#{i}")
        end_date    = input("datumbis#{i}")
        if start_date.present?
          begin
            (Date.parse(start_date)..Date.parse(end_date)).each do |date|
              res << { date: date, start_time: start_time, end_time: end_time,
                       notes: end_date, location_id: location_id }
            end
          rescue ArgumentError => e
            res << { start_time: start_time, end_time: end_time, notes: end_date, location_id: location_id }
            puts "Could not parse date #{input("datumvon#{i}")} or #{input("datumbis#{i}")} for seminar #{input 'seminarnr0'}"
          end
        else
          res << { start_time: start_time, end_time: end_time, notes: end_date, location_id: location_id }
        end
      end
      res
    end

    def others
      { free_places: checkbox('freieplaetze'), in_calendar: checkbox('inkalender') }
    end
  end

  class TeacherPage < PageImport
    def to_h
      {
        id:         input('id'),      profession: input('titel'),
        first_name: input('vorname'), last_name:  input('name'),
      }
    end
  end

  class LocationPage < PageImport
    def to_h
      { id: input('id'), name: input('ortkurz'), description: textarea('ort') }
    end
  end

  def self.import
    reset Seminar, Teacher, Location
    ActiveRecord::Base.logger.level = 1
    import_categories
    import_files_for Teacher,  TeacherPage,  'ref_*'
    import_files_for Location, LocationPage, 'ort_*'
    # import_files_for Seminar,  SeminarPage,  'sem_*'
    rebuild_search_index
    ActiveRecord::Base.logger.level = 0
  end

  def self.reset(*models)
    models.each do |model|
      model.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
    end
  end

  def self.import_categories
    puts 'run "rake db:seed"'
  end

  def self.import_files_for(model, page, suffix)
    files = Dir[Rails.root.join('db', 'seeds', suffix)]
    puts "import of #{files.count} #{model.name} files"
    files.each do |file|
      begin
        model.create! page.new(file).to_h
      rescue StandardError => e
        puts e.message, file
      end
    end
    puts "#{model.count} #{model.name} imported"
  end

  def self.rebuild_search_index
    PgSearch::Multisearch.rebuild(Teacher)
    PgSearch::Multisearch.rebuild(Location)
    PgSearch::Multisearch.rebuild(Seminar)
  end

end
