module SeminarsHelper
  def content_characters_for(seminar)
    strip_tags([seminar.content, seminar.benefit, seminar.notes].join).size
  end

  def current_seminar_numbers
    numbers = current_catalog.seminars.pluck(:number).sort
    course_regex = /(K)(\d+)\-(.*)/
    sem_regex = /([A-C])\-(\d+)\-(.*)/
    numbers = numbers.map { |num| num.scan(num[0] == 'K' ? course_regex : sem_regex) }.map(&:first).compact
    grouped = {}
    numbers.each do |(first, second, third)|
      grouped[first] ||= {}
      grouped[first][second] ||= []
      grouped[first][second] << third
    end
    grouped
  end
end
