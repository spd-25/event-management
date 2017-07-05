class SeminarPolicy < ApplicationPolicy

  def seminar
    record
  end

  def index?
    admin? || editor? || layouter?
  end

  def category?
    admin? || editor? || layouter?
  end

  def date?
    admin? || editor? || layouter?
  end

  def calendar?
    admin? || editor? || layouter?
  end

  def canceled?
    admin? || editor?
  end

  def layout?
    admin? || editor? || layouter?
  end

  def show?
    admin? || editor? || layouter?
  end

  def update?
    admin? || editor? || (layouter? && !seminar.published? && !seminar.catalog.published?)
  end

  def attendees?
    admin? || editor?
  end

  def pras?
    admin?
  end

  def versions?
    admin? || editor? || layouter?
  end

  def toggle_category?
    admin? || editor?
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

  def finish_layout?
    admin? || layouter?
  end

  def permitted_attributes
    attrs = %i(title subtitle benefit content notes date_text location_id)
    if admin? || editor?
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
