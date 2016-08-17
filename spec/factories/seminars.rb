FactoryGirl.define do
  factory :seminar do
    title "MyString"
    subtitle "MyString"
    teacher nil
    benefit "MyText"
    content "MyText"
    notes "MyText"
    max_attendees 1
    location nil
  end
end
