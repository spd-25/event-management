class UserPolicy < ApplicationPolicy

  def show?
    update?
  end

  def update?
    admin? || user == record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
