class CatalogPolicy < ApplicationPolicy

  def catalog
    record
  end

  def index?
    editor? || layouter?
  end

  def show?
    admin? or editor? or (layouter? and not catalog.published?)
  end

  def make_current?
    true
  end
end
