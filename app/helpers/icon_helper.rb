module IconHelper
  def locations_icon(text = nil)
    fa_icon 'map-marker', text: text
  end

  def teachers_icon(text = nil)
    fa_icon 'graduation-cap', text: text
  end

  def seminars_icon(text = nil)
    fa_icon 'university', text: text
  end

  def categories_icon(text = nil)
    fa_icon 'tags', text: text
  end

  def invoice_icon(text = nil)
    fa_icon 'file', text: text
  end

end
