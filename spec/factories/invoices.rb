FactoryGirl.define do
  factory :invoice do
    booking nil
    number "MyString"
    date "2016-08-29"
    address "MyText"
    pre_message "MyText"
    post_message "MyText"
    items ""
    status 1
    others ""
  end
end
