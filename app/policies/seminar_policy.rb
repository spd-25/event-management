class SeminarPolicy < ApplicationPolicy

  def index?
    admin? || editor? || layouter?
  end

  def category?
    index?
  end

  def date?
    index?
  end

  def calendar?
    index?
  end

  def canceled?
    index?
  end

  def show?
    admin? || editor? || layouter?
  end

  def update?
    admin? || editor?
  end

  def attendees?
    admin? || editor?
  end

  def pras?
    admin?
  end

  def versions?
    admin? || editor?
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

  class Scope < Scope
    def resolve
      scope
    end
  end
end
