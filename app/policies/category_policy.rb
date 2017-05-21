class CategoryPolicy < ApplicationPolicy

  def move?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
