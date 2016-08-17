module Importer
  def self.import
    # fetch_seminar '/seminar.php?id=2342'

    seminar_links.map do |link|
      sem_orig = fetch_seminar link

      sem_hash = sem_orig.slice(:title, :number, :content, :benefit, :notes, :due_date)
      sem_hash[:others] = sem_orig.except(:title, :number, :content, :benefit, :notes, :due_date)
      sem_hash[:year] = 2016
      Seminar.create!(sem_hash)
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
    res     = { link: link }
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
      'Ort'            => :location,
      'Gebühr'         => :price,
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
      { name: teacher.css('strong').text, prof: teacher.children[2].to_s }
    end
  end

  def self.get_dates(block)
    block.css('.nutzentext td').children.map(&:text).select(&:present?)
  end
end
