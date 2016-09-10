require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe '.next_number' do
    context 'no invoice exists already' do
      it 'gives a number starting with the current year' do
        expect(Invoice.next_number).to eql("#{Date.current.year}00001")
      end
    end

    context 'an invoice exists already' do
      before { FactoryGirl.create :invoice, number: '20161000' }
      it('gives the next number') { expect(Invoice.next_number).to eql('20161001') }
    end
  end
end
