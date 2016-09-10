require 'rails_helper'

RSpec.describe Seminar, type: :model do

  let(:cat_a) do
    build(:category, name: 'Cat A', categories: 2.times.map { |i| build(:category, name: "Cat A#{i + 1}") })
  end
  let(:cat_b) do
    build(:category, name: 'Cat B', categories: 2.times.map { |i| build(:category, name: "Cat B#{i + 1}") })
  end
  let(:cat_c) { build(:category, name: 'Cat C') }
  let(:cat_a_1) { cat_a.categories[0] }
  let(:cat_b_1) { cat_b.categories[0] }

  let(:seminar) { Seminar.new title: 'Sem 1234', categories: [cat_a, cat_a_1, cat_b_1, cat_c] }

  describe '#name' do
    it('s name equals its title') { expect(seminar.name).to eql 'Sem 1234' }
  end

  describe '#grouped_categories' do
    it "gives the related categories grouped by the category's hierarchy" do
      expect(seminar.grouped_categories).to eql({ cat_a => [cat_a_1], cat_b => [cat_b_1], cat_c => [] })
    end
  end

  describe '#parent_categories' do
    it 'gives all direct in indirect parent categories' do
      expect(seminar.parent_categories).to eql([cat_a, cat_b, cat_c])
    end
  end

end
