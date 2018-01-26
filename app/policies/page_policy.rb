class PagePolicy < ApplicationPolicy

  who_can(:create?)  { editor? }
  who_can(:update?)  { editor? }
  who_can(:destroy?) { editor? }

end
