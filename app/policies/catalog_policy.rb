class CatalogPolicy < ApplicationPolicy
  alias catalog record

  who_can(:index?)         { editor? || layouter? }
  who_can(:show?)          { admin? or editor? or (layouter? and not catalog.published?) }
  who_can(:make_current?)  { true }
end
