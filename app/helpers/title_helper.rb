module TitleHelper
  def locations_title
    locations_icon title_for_model(Location)
  end

  def teachers_title
    teachers_icon title_for_model(Teacher)
  end

  def seminars_title
    seminars_icon title_for_model(Seminar)
  end


  def categories_title
    title_for_model(Category)
  end

end
