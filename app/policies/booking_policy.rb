class BookingPolicy < ApplicationPolicy
  who_can(:show?)   { editor? }
  who_can(:create?) { editor? }
end
