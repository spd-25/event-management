class TeacherPolicy < ApplicationPolicy
  who_can(:index?)    { editor? }
  who_can(:show?)     { editor? }
  who_can(:create?)   { editor? }
  who_can(:update?)   { editor? }
  who_can(:seminars?) { editor? }
end
