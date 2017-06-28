class ApplicationPolicy
  attr_reader :user, :record
  delegate :admin?, :editor?, :layouter?, to: :user

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    admin? || editor?
  end

  def show?
    # scope.where(:id => record.id).exists?
    admin? || editor?
  end

  def create?
    user&.admin?
  end

  def new?
    create?
  end

  def update?
    admin?
  end

  def edit?
    update?
  end

  def destroy?
    admin?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
