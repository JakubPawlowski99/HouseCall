# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number)
    raise AssigningError::DeviceNotFound if device.nil?
    if device.user_id != @user.id
      raise AssigningError::AlreadyUsedOnOtherUser
    end
    device.update!(user_id: nil)
    DeviceHistory.create!(user: @user, device: device, action: 'returned')
  end
end