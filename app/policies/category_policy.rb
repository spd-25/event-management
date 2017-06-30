class CategoryPolicy < ApplicationPolicy

  def index?
    admin? || editor? || layouter?
  end

  def move?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
