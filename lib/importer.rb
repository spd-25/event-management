module Importer

  class PageImport

    attr_reader :doc, :data

    def initialize(file_name)
      @file_name = file_name
      @doc = Nokogiri::HTML(File.open(file_name), nil, 'UTF-8')
      @data = {}
      read
    rescue StandardError => e
      puts e.message, file_name
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
    def read
      count_dates      = input('termine').to_i
      count_teachers   = input('refs').to_i
      count_categories = input('themen').to_i
      #  time location_text date year
      data[:year]        = 2016
      data[:id]          = input 'id'
      data[:title]       = input 'titel'
      data[:subtitle]    = input 'untertitel'
      data[:number]      = input 'seminarnr0'
      data[:category_ids] = (0...count_categories).map { |i| select("thema#{i}") }.uniq
      data[:teacher_ids] = (0...count_teachers).map { |i| select("referent#{i}") }.uniq
      data[:location_id] = select('ort0')
      data[:benefit]     = textarea 'nutzen'
      data[:content]     = textarea 'inhalt'
      data[:notes]       = textarea 'bemerkungen'
      data[:price_text]  = textarea 'gebuehr'
      data[:due_date]    = textarea 'anmeldeschluss'
      data[:others] = {
        categories:  (0...count_categories).map { |i| select("thema#{i}") },
        dates_from:  (0...count_dates).map { |i| input("datumvon#{i}") },
        dates_to:    (0...count_dates).map { |i| input("datumbis#{i}") },
        time_from:   input('zeitvon'),
        time_to:     input('zeitbis'),
        free_places: checkbox('freieplaetze'),
        in_calendar: checkbox('inkalender'),
        locations:   (0...count_dates).map { |i| select("ort#{i}") }
      }
    end
  end

  class TeacherPage < PageImport
    def read
      data[:id]         = input 'id'
      data[:first_name] = input 'vorname'
      data[:last_name]  = input 'name'
      data[:profession] = input 'titel'
    end
  end

  class LocationPage < PageImport
    def read
      data[:id]          = input 'id'
      data[:name]        = input 'ortkurz'
      data[:description] = textarea 'ort'
    end
  end

  def self.import
    reset Seminar, Teacher, Location
    ActiveRecord::Base.logger.level = 1
    import_categories
    import_files_for Teacher,  TeacherPage,  'ref_*'
    import_files_for Location, LocationPage, 'ort_*'
    import_files_for Seminar,  SeminarPage,  'sem_*'
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
    files.each { |file| create! model, page.new(file).data, file }
    puts "#{model.count} #{model.name} imported"
  end

  def self.create!(model, data, file)
    model.create! data
  rescue StandardError => e
    puts e.message, data, file
  end

end
