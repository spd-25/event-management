class CategoryPolicy < ApplicationPolicy
  who_can(:index?) { editor? || layouter? }
  who_can(:move?)  { update? }
end
