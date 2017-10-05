class UserPolicy < ApplicationPolicy

  def show?
    update?
  end

  def seminars?
    editor?
  end

  def update?
    admin? || user == record
  end

  def access_rights?
    editor?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
