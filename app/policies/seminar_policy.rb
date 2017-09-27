class SeminarPolicy < ApplicationPolicy

  def seminar
    record
  end

  def index?
    editor? || layouter?
  end

  def category?
    editor? || layouter?
  end

  def date?
    editor? || layouter?
  end

  def calendar?
    editor? || layouter?
  end

  def canceled?
    editor?
  end

  def editing_status?
    editor? || layouter?
  end

  def show?
    editor? || layouter?
  end

  def update?
    editor? || (layouter? && !seminar.published? && !seminar.catalog.published?)
  end

  def attendees?
    editor?
  end

  def pras?
    admin?
  end

  def versions?
    editor? || layouter?
  end

  def toggle_category?
    editor?
  end

  def search?
    admin?
  end

  def publish?
    admin?
  end

  def unpublish?
    publish?
  end

  def finish_editing?
    editor?
  end

  def finish_layout?
    layouter?
  end

  def permitted_attributes
    attrs = %i(title subtitle benefit content notes date_text location_id editor_id)
    if editor?
      attrs += %i(
        number price price_text key_words parent_id max_attendees archived canceled copy_from_id
      )

      attrs << {
        teacher_ids: [],
        events_attributes: [:id, :location_id, :date, :start_time, :end_time, :notes],
        statistic:         AttendeeStatistic.attribute_set.map(&:name)
      }
    end
    attrs
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
