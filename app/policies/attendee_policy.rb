class AttendeePolicy < ApplicationPolicy

  def cancel?
    destroy?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
