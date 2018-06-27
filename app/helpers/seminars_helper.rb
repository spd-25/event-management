module SeminarsHelper
  def content_characters_for(seminar)
    strip_tags([seminar.content, seminar.benefit, seminar.notes].join).size
  end
end
