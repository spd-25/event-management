class AttendeePolicy < ApplicationPolicy
  who_can(:cancel?) { editor? }
end
