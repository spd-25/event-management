FactoryGirl.define do
  factory :attendee do
    seminar nil
    booking nil
    first_name "MyString"
    last_name "MyString"
    address ""
    contact ""
    profession "MyString"
    gender "MyString"
    age 1
  end
end
