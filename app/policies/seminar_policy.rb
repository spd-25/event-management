class SeminarPolicy < ApplicationPolicy

  def index?
    super || user.editor?
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
    index?
  end

  def update?
    index?
  end

  def attendees?
    index?
  end

  def pras?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
