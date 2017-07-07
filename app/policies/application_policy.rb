class ApplicationPolicy
  attr_reader :user, :record
  delegate :admin?, to: :user

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    editor?
  end

  def show?
    # scope.where(:id => record.id).exists?
    editor?
  end

  def create?
    admin?
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

  def editor?
    admin? || user.editor?
  end

  def layouter?
    admin? || user.layouter?
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
