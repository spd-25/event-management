require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:parent) { Category.new name: 'Cat1' }
  let(:child)  { Category.new name: 'Cat2', category: parent }

  describe '#parent?' do
    it('is true for parents')   { expect(parent).to    be_parent }
    it('is false for children') { expect(child).not_to be_parent }
  end
end
