class Downloader

  attr_reader :agent

  def self.download_from_backend
    new.download_all
  end

  def initialize
    @agent = Mechanize.new
  end

  def download_all
    # login_seminars
    # download_teachers
    # download_locations
    # download_seminars
    # logout

    login_invoices
    download_seminar_details
    download_companies
    logout
  end

  def download_teachers
    agent.page.link_with(text: 'Referenten').click
    download_pages 'ref', 'referenten'
  end

  def download_locations
    agent.page.link_with(text: 'Seminarorte').click
    download_pages 'ort', 'seminarorte'
  end

  def download_seminars
    agent.page.link_with(text: 'Seminare').click
    agent.page.link_with(text: '2016').click
    download_pages 'sem', 'seminare'
  end

  def download_seminar_details
    agent.page.link_with(text: 'Seminar-Details').click
    agent.page.link_with(text: '2016').click
    download_pages 'sem_det', 'seminar_details'
  end

  def download_companies
    agent.page.link_with(text: 'Firmen').click
    download_pages 'comp', 'firmdaten_editieren'
  end

  def download_pages(prefix, target)
    agent.page.links.each do |link|
      next unless link.href.include?("index.php?target=#{target}")
      download_page link.href, prefix
    end
  end

  def download_page(link, prefix)
    id = CGI::parse(URI.parse(link).query)['id'].first
    agent.get link
    open(Rails.root.join('db', 'seeds', "#{prefix}_#{id}.html"), 'wb') do |file|
      file << agent.page.search('form').to_s
    end
  rescue StandardError => e
    puts e.message, link
  end

  def login_seminars
    login 'http://buchung.bildungswerk-lsa.de/admin'
  end

  def login_invoices
    login 'http://buchung.bildungswerk-lsa.de/rechnungen/'
  end

  def login(url)
    agent.get(url)
    form = agent.page.forms.first
    form.username = ENV['PARI_USER']
    form.password = ENV['PARI_PW']
    agent.submit form
  end

  def logout
    agent.page.link_with(text: 'Logout').click
  end
end
