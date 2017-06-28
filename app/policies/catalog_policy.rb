class CatalogPolicy < ApplicationPolicy
  def index?
    admin? || editor? || layouter?
  end

  def make_current?
    true
  end
end
