# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number)

    if device && device.user_id == @user.id
      device.update!(user_id: nil)
      ReturnedDevice.create!(user: @user, device: device)
    elsif device
      raise AssigningError::AlreadyUsedOnOtherUser
    else
      raise AssigningError::DeviceNotFound
    end
  end
end