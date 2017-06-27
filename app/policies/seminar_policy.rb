class SeminarPolicy < ApplicationPolicy

  def index?
    user.role.in? %w(admin editor layouter)
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
    user.role.in? %w(admin editor layouter)
  end

  def update?
    user.role.in? %w(admin editor)
  end

  def attendees?
    user.role.in? %w(admin editor)
  end

  def pras?
    user.admin?
  end

  def versions?
    user.role.in? %w(admin editor)
  end

  def toggle_category?
    user.role.in? %w(admin editor)
  end

  def search?
    user.admin?
  end

  def publish?
    user.admin?
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
