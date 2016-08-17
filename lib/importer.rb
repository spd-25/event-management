module Importer
  def self.import
    seminars = fetch_seminars
    locations = store_locations(seminars)
    # teachers = store_teachers(seminars)

    seminars.each do |sem_orig|
      attrs = %i(title number content benefit notes due_date price_text time location_text date year)
      sem_hash            = sem_orig.slice(*attrs)
      sem_hash[:others]   = sem_orig.except(*attrs)
      location            = locations[sem_hash[:location_text]]
      sem_hash[:location] = location if location

      begin
        Seminar.create!(sem_hash)
      rescue ActiveRecord::RecordInvalid => e
        puts e.record, e.message, sem_hash
      end
    end
    nil
  end

  def self.fetch_seminars
    seminar_links[0..50].map do |link|
      res = fetch_seminar link
      res[:location_text] = res.delete(:location_text)&.split('<br>')&.join("\n")
      res[:date_text]     = res.delete(:date)&.join("\n")
      res
    end
  end

  def self.store_locations(seminars)
    seminars.map { |sem| sem[:location_text] }.uniq.each_with_object({}) do |loc, locations|
      begin
        locations[loc] = Location.create! name: loc if loc.present?
      rescue ActiveRecord::RecordInvalid => e
        puts e.record, e.message, loc
      end
    end
  end

  def self.store_teachers(seminars)
    teachers = []
    seminars.each { |sem| teachers += sem[:teachers ]}
    teachers.uniq.each_with_object({}) do |teacher, teachers_hash|
      begin
        teachers_hash[teacher] = Teacher.create! teacher
      rescue ActiveRecord::RecordInvalid => e
        puts e.record, e.message, teacher
      end
    end
  end

  def self.seminar_links
    doc = Nokogiri::HTML(open(url_base + '/katalog.php?jahr=2016'))
    doc.xpath('//div[@id="textlinks"]//a[contains(@href, "seminar")]/@href').map(&:to_s)
  end

  def self.url_base
    'http://buchung.bildungswerk-lsa.de'
  end

  def self.fetch_seminar(link)
    link    = '/' + link unless link.starts_with?('/')
    res     = { link: link, year: 2016 }
    doc     = Nokogiri::HTML(open(url_base + link))
    content = doc.css('#textlinks').first

    res[:title]      = content.css('h1.titel').text.strip
    res[:number]     = content.css('.seminarklammer .seminarnummer').text.strip
    res[:categories] = content.css('.seminarklammer .seminarthema').text.strip.split(' |').map(&:strip)
    res.merge parse_blocks(content)
  end

  def self.parse_blocks(content)
    content.css('.nutzenklammer').each_with_object({}) do |block, res|
      key, content = content_for(block)
      res[key] = content
    end
  end

  def self.key_for(block)
    {
      'Nutzen'         => :benefit,
      'Inhalt'         => :content,
      'Bemerkungen'    => :notes,
      'Referenten'     => :teachers,
      'Datum'          => :date,
      'Zeit'           => :time,
      'Ort'            => :location_text,
      'Gebühr'         => :price_text,
      'Anmeldeschluss' => :due_date,
    }[block.css('.nutzenueber').text]
  end

  def self.content_for(block)
    key = key_for(block)
    content = case key
    when :teachers then get_teachers(block)
    when :date     then get_dates(block)
    else                get_html(block)
    end
    [key, content]
  end

  def self.get_html(block)
    content = block.css('.nutzentext')
    content = block.css('.nutzentext>div') if content.inner_html.include?('nutzentext')
    content.inner_html.chomp.strip
  end

  def self.get_teachers(block)
    block.css('.nutzentext p').map do |teacher|
      name = teacher.css('strong').text.split
      {
        title: name[-3],
        first_name: name[-2],
        last_name: name[-1],
        profession: teacher.children[2].to_s
      }
    end
  end

  def self.get_dates(block)
    block.css('.nutzentext td').children.map(&:text).select(&:present?)
  end
end
