class SeminarPolicy < ApplicationPolicy

  def index?
    super || user.editor?
  end

  def show?
    index?
  end

  def update?
    index?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
