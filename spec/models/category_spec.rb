require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:parent) { Category.new name: 'Cat1' }
  let(:child)  { Category.new name: 'Cat2', parent: parent }

  describe '#root?' do
    it('is true for parents')   { expect(parent).to    be_root }
    it('is false for children') { expect(child).not_to be_root }
  end
end
