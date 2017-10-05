class UserPolicy < ApplicationPolicy

  def show?
    update?
  end

  def update?
    admin? || user == record
  end

  def access_rights?
    admin? || editor?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
