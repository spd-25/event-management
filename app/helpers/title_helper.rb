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
    categories_icon title_for_model(Category)
  end

  def users_title
    users_icon title_for_model(User)
  end

end
