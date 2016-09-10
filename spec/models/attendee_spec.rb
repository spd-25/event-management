require 'rails_helper'

RSpec.describe Attendee, type: :model do

  let(:address) { { street: 'Street', zip: '01234', city: 'Berlin' } }
  let(:attendee) { Attendee.new(first_name: 'John', last_name: 'Meyer', address: address) }

  describe '#name' do
    it 'gives the full name' do
      expect(attendee.name).to eql('John Meyer')
    end
  end

  describe '#full_address' do
    it 'gives the full address' do
      expect(attendee.full_address).to eql("John Meyer\nStreet\n01234 Berlin")
    end
  end
end
