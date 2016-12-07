class UserPolicy < ApplicationPolicy

  def destroy?
    super && user != record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
