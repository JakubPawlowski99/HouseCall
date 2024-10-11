# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number, user_id: @user.id)
    
    if device
      device.update!(user_id: nil)
      ReturnedDevice.create!(user: @user, device: device)
    else
      raise AssigningError::AlreadyUsedOnOtherUser
    end
  end
end