require 'rails_helper'

RSpec.describe DeviceHistory, type: :model do
  subject(:device_history) { create(:device_history) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(device_history).to be_valid
    end
  end

  context 'associations' do
    it 'belongs to a user' do
      expect(device_history.user).to be_present
    end

    it 'belongs to a device' do
      expect(device_history.device).to be_present
    end
  end

  context 'validations' do
    it 'is invalid without a user_id' do
      device_history.user = nil
      expect(device_history).to_not be_valid
    end

    it 'is invalid without a device_id' do
      device_history.device = nil
      expect(device_history).to_not be_valid
    end

    it 'is invalid without an action' do
      device_history.action = nil
      expect(device_history).to_not be_valid
    end
  end
end
