class TeacherPolicy < ApplicationPolicy
  def create?
    editor?
  end

  def update?
    editor?
  end

  def seminars?
    editor?
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
