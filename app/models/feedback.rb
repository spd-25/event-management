class Feedback < ApplicationRecord
  belongs_to :user
  validates :subject, :message, presence: true
end
