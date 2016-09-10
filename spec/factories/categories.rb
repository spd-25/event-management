FactoryGirl.define do
  # factory :category do
  #   name "MyString"
  #   category nil
  # end
  #
  # factory :parent1, class: Category do
  #   name 'parent1'
  # end
  #
  # factory :parent2, class: Category do
  #   name 'parent2'
  # end
  #
  # factory :parent3, class: Category do
  #   name 'parent3'
  # end
  #
  # factory :child1, class: Category do
  #   name 'child1'
  #   association :category, factory: :parent1
  # end

  #   child1 = Category.new name: 'Child1', category: parent1
  #   child2 = Category.new name: 'Child2', category: parent1
  # parent2 = Category.new name: 'parent2'
  #   child3 = Category.new name: 'Child3', category: parent2
  #   child4 = Category.new name: 'Child4', category: parent2
  # parent3 = Category.new name: 'parent3'


  factory :category do
    name 'Cat'

    factory :child_category do
      name 'Sub cat'
      association :category, factory: :parent_category, strategy: :build
    end

    factory :parent_category do
      # transient do
      #   children_count 3
      # end

      # after(:build) do |parent, evaluator|
      #   puts 'X'*80
      #   build_list(:child_category, evaluator.children_count, category: parent)
      # end
    end
  end
end
