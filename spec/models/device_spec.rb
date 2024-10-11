require 'rails_helper'

RSpec.describe Device, type: :model do
  subject(:device) { build(:device) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(device).to be_valid
    end
  end

  context 'associations' do
    it 'is optional user association' do
      expect(device.user).to be_nil
    end
  end
end