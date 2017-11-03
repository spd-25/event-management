class AttendeePolicy < ApplicationPolicy
  who_can(:cancel?) { destroy? }
end
