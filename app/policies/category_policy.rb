class CategoryPolicy < ApplicationPolicy
  who_can(:index?)  { editor? || layouter? }
  who_can(:update?) { editor? }
  who_can(:move?)   { update? }
end
