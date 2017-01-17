FactoryGirl.define do
  factory :invoice do
    number '1234'
    date { Date.current }
    address "John Meyer\nStreet\n01234 Berlin"
    pre_message "MyText"
    post_message "MyText"
    status 1
  end
end
