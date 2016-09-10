require 'rails_helper'

RSpec.describe Teacher, type: :model do

  let(:teacher) { FactoryGirl.build :teacher }

  describe '#name' do
    it 'concatenates all infos' do
      expect(teacher.name).to eql('Dr. John Teacher')
    end
  end

end
