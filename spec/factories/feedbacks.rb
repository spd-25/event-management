FactoryGirl.define do
  factory :feedback do
    subject 'Problem'
    message 'Something is not working'
    path 'https://server.com/path'
    user { create :user, name: 'feedbacker' }
  end
end
