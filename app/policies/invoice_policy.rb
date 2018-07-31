class InvoicePolicy < ApplicationPolicy
  who_can(:index?)    { finance? || editor? }
  who_can(:show?)     { finance? || editor? }
  who_can(:create?)   { finance? }
  who_can(:update?)   { finance? }
  who_can(:destroy?)  { finance? }
end
