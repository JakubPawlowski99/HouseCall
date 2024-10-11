require 'rails_helper'

RSpec.describe ReturnedDevice, type: :model do
  subject(:returned_device) { build(:returned_device) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(returned_device).to be_valid
    end

    it 'belongs to a user' do
      expect(returned_device.user).to be_present
    end

    it 'belongs to a device' do
      expect(returned_device.device).to be_present
    end
  end
end