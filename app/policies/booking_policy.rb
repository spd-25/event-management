class BookingPolicy < ApplicationPolicy

  def create?
    true
  end

  def cancel?
    destroy?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
