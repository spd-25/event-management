class LocationPolicy < ApplicationPolicy
  who_can(:create?) { editor? }
  who_can(:update?) { editor? }
end
