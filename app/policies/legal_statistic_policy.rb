class LegalStatisticPolicy < ApplicationPolicy
  who_can(:index?)  { admin? }
  who_can(:show?)   { admin? }
  who_can(:update?) { admin? }
end
