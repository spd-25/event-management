class AttendeePolicy < ApplicationPolicy
  who_can(:destroy?) { editor?  }
  who_can(:cancel?)  { destroy? }
  who_can(:update?)  { editor? }
end
