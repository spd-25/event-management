class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
  after_initialize :set_default_role, if: :new_record?

  validates :email, :username, :role, presence: true

  has_paper_trail

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
