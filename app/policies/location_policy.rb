class LocationPolicy < ApplicationPolicy
  who_can(:update?) { editor? }
end
