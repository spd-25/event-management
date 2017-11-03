class UserPolicy < ApplicationPolicy
  who_can(:show?)          { update? }
  who_can(:seminars?)      { editor? }
  who_can(:update?)        { admin? || user == record }
  who_can(:access_rights?) { editor? }
end
