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


  describe '#dates' do
    context 'seminar has no events' do
      subject { described_class.new.dates }
      it('gives an empty array') { expect(subject).to eq([]) }
    end

    context 'seminar has one event' do
      subject { described_class.new(events_attributes: [{ date: '01.01.2016' }]).dates }
      it('gives the date of the event') { expect(subject).to eq([Date.new(2016, 1, 1)]) }
    end

    context 'seminar has events in one row' do
      subject do
        events = [{ date: '01.01.2016' }, {date: '02.01.2016'}, {date: '03.01.2016'}]
        described_class.new(events_attributes: events).dates
      end
      it('gives an array with one date range') do
        expect(subject).to eq([(Date.new(2016, 1, 1)..Date.new(2016, 1, 3))])
      end
    end

    context 'seminar has events in multiple rows' do
      subject do
        events = [
          { date: '01.01.2016' }, { date: '02.01.2016'}, { date: '03.01.2016'},
          { date: '07.02.2016' }, { date: '08.02.2016'}, { date: '09.02.2016'},
          { date: '10.03.2016' }, { date: nil },
        ]
        described_class.new(events_attributes: events).dates
      end
      it('gives an array with 2 date ranges and one date') do
        expect(subject).to eq([
                                (Date.new(2016, 1, 1)..Date.new(2016, 1, 3)),
                                (Date.new(2016, 2, 7)..Date.new(2016, 2, 9)),
                                Date.new(2016, 3, 10)
                              ])
      end
    end

  end

end
