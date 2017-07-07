class CategoryPolicy < ApplicationPolicy

  def index?
    editor? || layouter?
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
