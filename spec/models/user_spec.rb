require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(user).to be_valid
    end
  end

  context 'when user has no devices' do
    it 'is valid without devices' do
      expect(user.devices.count).to eq(0)
    end
  end
end