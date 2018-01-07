class PagePolicy < ApplicationPolicy

  who_can(:home?) { true }
  who_can(:show?) { record.published? || user&.admin? }

end
