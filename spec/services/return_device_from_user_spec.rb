# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReturnDeviceFromUser do
  subject(:return_device) do
    described_class.new(user: user, serial_number: serial_number).call
  end

  let(:user) { create(:user) }
  let(:serial_number) { '123456' }

  context 'when the user has the device' do
    before do
      AssignDeviceToUser.new(
        requesting_user: user,
        serial_number: serial_number,
        new_device_owner_id: user.id
      ).call
    end

    it 'returns the device successfully' do
      expect { return_device }.to change { user.devices.count }.by(-1)
    end
  end

  context 'when the user does not own the device' do
    let(:other_user) { create(:user) }

    before do
      AssignDeviceToUser.new(
        requesting_user: other_user,
        serial_number: serial_number,
        new_device_owner_id: other_user.id
      ).call
    end

    it 'raises an error' do
      expect { return_device }.to raise_error(AssigningError::AlreadyUsedOnOtherUser)
    end
  end
end