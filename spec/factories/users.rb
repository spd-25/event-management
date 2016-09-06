FactoryGirl.define do
  factory :user do
    name "Test User"
    email "test@example.com"
    username "testuser"
    password "please123"
    password_confirmation "please123"

  end

  # factory :admin, class: User do
  #   name "Admin User"
  #   email "admin@example.com"
  #   username "admin"
  #   password "please123"
  #
  #   trait :admin do
  #     role 'admin'
  #   end
  #
  # end
end
