class TeacherPolicy < ApplicationPolicy
  def create?
    admin? || editor?
  end

  def update?
    admin? || editor?
  end

  def seminars?
    admin? || editor?
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
