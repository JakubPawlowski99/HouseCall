# frozen_string_literal: true

require 'rspec'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) { described_class.new(user: user, serial_number: serial_number).call }

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }
  let!(:device) { create(:device, serial_number: serial_number, user: user) }

  context 'when the user is the owner of the device' do
    it 'allows the user to return the device' do
      expect { return_device }.not_to raise_error
      expect(device.user).to be_nil
    end
  end

  context 'when the user is not the owner of the device' do
    let(:another_user) { create(:user) }

    it 'raises an error' do
      expect { described_class.new(user: another_user, serial_number: serial_number).call }.to raise_error(AssigningError::Unauthorized)
    end
  end
end
