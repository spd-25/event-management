require 'rails_helper'

RSpec.describe Seminar, type: :model do

  let(:cat_a) do
    # build(:category, name: 'Cat A', children: 2.times.map { |i| build(:category, name: "Cat A#{i + 1}") })
    children = Array.new(2) { |i| build(:category, name: "Cat A#{i + 1}") }
    build(:category, name: 'Cat A', children: children)
  end
  let(:cat_b) do
    build(:category, name: 'Cat B', children: 2.times.map { |i| build(:category, name: "Cat B#{i + 1}") })
  end
  let(:cat_c) { build(:category, name: 'Cat C') }
  let(:cat_a_1) { cat_a.children[0] }
  let(:cat_b_1) { cat_b.children[0] }

  let(:seminar) { Seminar.new title: 'Sem 1234', categories: [cat_a, cat_a_1, cat_b_1, cat_c] }

  describe '#name' do
    it('s name equals its title') { expect(seminar.name).to eql 'Sem 1234' }
  end

  describe '#events_list' do

    let(:events) do
      [
        { date: '01.01.2016', start_time: '9:00', end_time: '13:00' },
        { date: '02.01.2016', start_time: '9:00', end_time: '13:00' },
        { date: '03.01.2016', start_time: '9:00', end_time: '13:00' },
        { date: '04.01.2016', start_time: '9:00', end_time: '12:00' },
        { date: '30.01.2016', start_time: '9:00', end_time: '12:00' },
        { date: '31.01.2016', start_time: '9:00', end_time: '12:00' },
        { date: '01.02.2016', start_time: '9:00', end_time: '12:00' },
      ]
    end
    subject { Seminar.new(events_attributes: events).decorate.events_list }
    specify do
      expect(subject.grouped).to eq(
        Date.new(2016, 1, 1)..Date.new(2016, 1, 3)  => '9:00 - 13:00',
        Date.new(2016, 1, 4)                        => '9:00 - 12:00',
        Date.new(2016, 1, 30)..Date.new(2016, 2, 1) => '9:00 - 12:00',
      )
    end
  end
end
