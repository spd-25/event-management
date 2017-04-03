class TeacherPolicy < ApplicationPolicy
  def update?
    user.admin? || user.editor?
  end

  def seminars?
    user.admin?
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
